require 'acceptance/acceptance_helper'

feature "Comments questions", %q{
        In order to give an explanation to question
        As an user
        I want to be able add comment
                            } do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe "Authenticated user" do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "have link for comment" do
      within "#answer_#{answer.id}" do
        expect(page).to have_link "Написать комментарий"
      end
    end

    context "with valid attributes" do
      scenario "create comment", js: true do
        within "#answer_#{answer.id}" do
          click_on "Написать комментарий"

          within ".comment-form" do
            fill_in "Body", with: "New test comment"
            click_on  "Написать"
          end

          expect(page).to have_content "New test comment"
          expect(page).to have_content user.email
        end
      end
    end

    context "with invalid attributes" do
      scenario "not create comment", js: true do
        within "#answer_#{answer.id}" do
          click_on "Написать комментарий"

          within ".comment-form" do
            fill_in "Body", with: ""
            click_on  "Написать"
          end

          expect(page).to_not have_content "New test comment"
          expect(page).to_not have_content user.email
          expect(page).to have_content "2 errors prohibited this comment from being saved:"
        end
      end
    end

  end

  describe "non-authenticated user" do
    scenario "don't have link for comment" do
      visit question_path(question)

      within "#answer_#{answer.id}" do
        expect(page).to_not have_link "Написать комментарий"
      end
    end
  end
end