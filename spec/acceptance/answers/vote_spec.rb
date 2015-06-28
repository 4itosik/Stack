require 'acceptance/acceptance_helper'

feature "Vote to answer", %q{
        In order to like or dislike answer
        As an user
        I want to be able vote for answer
                          } do

  describe "Authenticated user" do
    let(:user) { create(:user) }

    describe "owner answer" do
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question, user: user) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario "vote for answer" do
        within "#answer_#{answer.id}" do
          expect(page).to_not have_link "Like"
          expect(page).to_not have_link "Dislike"
        end
      end
    end

    describe "non-owner answer" do
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      describe "like" do
        scenario "have link to vote for answer" do
          within "#answer_#{answer.id}" do
            expect(page).to have_link "Like"
          end
        end

        scenario "vote for answer", js: true do
          within "#answer_#{answer.id}" do
            click_on "Like"

            expect(page).to_not have_link "Like"
            expect(page).to_not have_link "Disike"
            expect(page).to have_content "1"
            expect(page).to have_link "Cancel"
          end
        end
      end

      describe "dislike" do
        scenario "have link to vote for answer" do
          within "#answer_#{answer.id}" do
            expect(page).to have_link "Dislike"
          end
        end

        scenario "vote for answer", js: true do
          within "#answer_#{answer.id}" do
            click_on "Dislike"

            expect(page).to_not have_link "Like"
            expect(page).to_not have_link "Disike"
            expect(page).to have_content "-1"
            expect(page).to have_link "Cancel"
          end
        end
      end
    end
  end


  describe "non-authenticated user" do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    scenario "vote for answer" do
      visit question_path(question)

      within "#answer_#{answer.id}" do
        expect(page).to_not have_link "Like"
        expect(page).to_not have_link "Dislike"
      end
    end

  end

  describe "owner cancel vote" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let!(:vote) { create(:vote, voteable: answer, user: user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "have link" do
      within "#answer_#{answer.id}" do
        expect(page).to have_link "Cancel"
      end
    end

    scenario "cancel vote", js: true do
      within "#answer_#{answer.id}" do
        click_on "Cancel"

        expect(page).to have_content "0"
        expect(page).to have_link "Like"
        expect(page).to have_link "Dislike"
      end
    end
  end

end