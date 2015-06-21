require 'acceptance/acceptance_helper.rb'

feature 'Create answer for question', %q{
        In order to add answer for question
        As an user
        I want to be able to ask the answer for question
                                    } do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario "Authenticated user create the answer", js: true do
    sign_in(user)
    visit question_path(question)
    fill_in "Body", with: "New test big answer for this question"
    click_on  "Save answer"
    within '.answers' do
      expect(page).to have_content "New test big answer for this question"
    end
  end

  scenario "Non-authenticated user create the answer" do
    visit question_path(question)
    expect(page).to_not have_button "Save answer"
  end

  scenario "Authenticated user create the question with invalid attributes", js: true do
    sign_in(user)
    visit question_path(question)
    fill_in "Body", with: "Small body answer"
    click_on "Save answer"
    within '#answer-form' do
      expect(page).to have_content "1 error prohibited this answer from being saved:"
    end
  end
end