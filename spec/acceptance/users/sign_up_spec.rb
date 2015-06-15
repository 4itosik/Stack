require 'acceptance/acceptance_helper.rb'

feature "Sign up", %q{
        In order to be sign in to system
        As an user
        I wont to be registrations
                 } do

  given(:build_user) { build(:user) }
  given(:user) { create(:user) }

  scenario "Non-existing user try to sign up" do
    sign_up(build_user)
    expect(page).to have_content "Welcome! You have signed up successfully."
  end

  scenario "Existing user try to sign up" do
    sign_up(user)
    expect(page).to have_content "Email has already been taken"
  end

end