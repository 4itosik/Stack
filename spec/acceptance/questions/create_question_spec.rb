require 'acceptance/acceptance_helper.rb'

feature 'Create question', %q{
        In order to get answer for community
        As an user
        I want to be able to ask the question
                         } do

  given(:user) { create(:user) }

  scenario "Authenticated user create the question", js: true do
    sign_in(user)
    visit questions_path

    click_on "Add question"
    fill_in 'Title', with: "Test string 15 length"
    fill_in "Body", with: "Test body Test body Test body "
    click_on "Add question"

    expect(page).to have_content "Test string 15 length"
    expect(page).to have_content "Test body Test body Test body "
  end

  scenario "non-authenticated user create the question" do
    visit questions_path
    click_on "Add question"

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end

  scenario "Authenticated user create the question with invalid attributes", js: true do
    sign_in(user)
    visit questions_path

    click_on "Add question"
    fill_in 'Title', with: "Small string"
    fill_in "Body", with: "Small body"
    click_on "Add question"

    expect(page).to have_content "2 errors prohibited this question from being saved:"
  end
end