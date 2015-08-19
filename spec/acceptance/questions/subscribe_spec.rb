require 'acceptance/acceptance_helper.rb'

feature 'Subscribe questions', %q{
        In order to get email about new answer
        As an user
        I want to be able subscribe question
                                 } do

  let(:user) { create(:user) }
  let!(:question) { create(:question) }

  describe "Authenticated user" do
    context "non subscribe for question" do
      scenario "Can subscribe to question", js: true do
        sign_in(user)
        visit question_path(question)

        expect(page).to have_link "Подписаться"

        click_on "Подписаться"

        expect(page).to_not have_link "Подписаться"
        expect(page).to have_content "Вы подписаны на данный вопрос"
      end
    end

    context "subscribe for question" do
      let!(:subscribe) { create(:subscribe, user: user, question: question) }

      scenario "Can not subscribe to question" do
        sign_in(user)
        visit question_path(question)

        expect(page).to_not have_link "Подписаться"
      end
    end
  end

  describe "non-authenticated user" do
    scenario "Can not subscribe to question" do
      visit question_path(question)

      expect(page).to_not have_link "Подписаться"
    end
  end

end