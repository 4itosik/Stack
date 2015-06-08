require 'rails_helper'

feature "Delete answer", %q{
         In order to delete answer
         As an user
         I want to be able owner this answer
                          } do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  before { create(:answer, question: question, user: user) }
  given(:other_user) { create(:user) }

  scenario "Owner user try to delete answer" do
    sign_in(user)
    visit question_path(question)
    click_on "Delete answer"
    expect(page).to have_content "Your answer successfully destroy"
    expect(page).to_not have_content "Test big body for answer for question"
  end

  scenario "non-owner user try to delete question" do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to_not have_content "Delete answer"
  end

end