require 'rails_helper'

feature "Delete question", %q{
         In order to delete question
         As an user
         I want to be able owner this question
                          } do

  given(:user) { create(:user) }
  before { create(:question, user: user ) }
  given(:other_user) { create(:user) }

  scenario "Owner user try to delete question" do
    sign_in(user)
    visit questions_path
    click_on "Delete question"
    expect(page).to have_content "Your question successfully destroy"
    expect(page).to_not have_content "Test string 15 length"
    expect(page).to_not have_content "Test body Test body Test body "
  end

  scenario "non-owner user try to delete question" do
    sign_in(other_user)
    visit questions_path
    expect(page).to_not have_content "Delete question"
  end

end