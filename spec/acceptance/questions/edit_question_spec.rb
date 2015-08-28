require 'acceptance/acceptance_helper.rb'

feature "Edit and update question", %q{
        In order to edit and update question
        As an user
        I want to be able owner this question
                       } do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user ) }
  given(:other_user) { create(:user) }

  scenario "Owner user try to edit question" do
    sign_in(user)
    visit question_path(question)

    click_on "Edit question"

    fill_in "Title", with: "New test string "
    fill_in "Body", with: "New test big body for question"

    click_on "Update question"

    expect(page).to have_content "Your question successfully update"
    expect(page).to have_content "New test string "
    expect(page).to have_content "New test big body for question"
  end

  scenario "non-owner user try to edit question" do
    sign_in(other_user)
    visit questions_path
    expect(page).to_not have_content "Edit question"
  end

end