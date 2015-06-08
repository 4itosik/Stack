require 'rails_helper'

feature 'Sign in', %q{
        In order to be able ask questions or write answers
        As an user
        I want to be sign in
                      } do

  given(:user) { create(:user) }

  scenario "Existing user try to sign in" do
    sign_in(user)
    expect(page).to have_content "Signed in successfully."
  end

  scenario "Non-existing user try to sign in" do
    visit new_user_session_path
    fill_in "Email", with: "any_user@user.ru"
    fill_in "Password", with: "wrong password"
    click_on "Log in"
    expect(page).to have_content "Invalid email or password."
  end

  scenario "Existing user try to sign in again" do
    sign_in(user)
    visit new_user_session_path
    expect(page).to have_content "You are already signed in."
  end

end