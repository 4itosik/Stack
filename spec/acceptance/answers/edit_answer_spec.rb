require 'rails_helper'

feature "Edit and update answer", %q{
         In order to edit answer
         As an user
         I want to be able owner this answer
                          } do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  before { create(:answer, question: question, user: user) }
  given(:other_user) { create(:user) }

  scenario "Owner user try to edit answer" do
    sign_in(user)
    visit question_path(question)
    click_on "Edit answer"
    fill_in "Body", with: "New test big body for answer..."
    click_on "Update answer"
    expect(page).to have_content "Your answer successfully update"
    expect(page).to have_content "New test big body for answer..."
  end

  scenario "non-owner user try to edit question" do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to_not have_content "Edit answer"
  end

end