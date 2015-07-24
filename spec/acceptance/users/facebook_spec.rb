require 'acceptance/acceptance_helper.rb'

feature "Sign in facebook", %q{
        In order to be able login without email and password
        As an user
        I want to be able sign in from facebook
                          } do

  background { visit new_user_session_path }

  scenario "Existing user try to sign in" do
    expect(page).to have_link "Sign in with Facebook"

    mock_auth_hash(:facebook)
    click_on "Sign in with Facebook"

    expect(page).to have_content "Successfully authenticated from Facebook account."
    expect(page).to_not have_link "Login"
    expect(page).to have_link "Sign out"
  end

  scenario "Authentication error" do
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials

    click_on "Sign in with Facebook"

    expect(page).to have_content 'Could not authenticate you from Facebook because "Invalid credentials".'
  end
end