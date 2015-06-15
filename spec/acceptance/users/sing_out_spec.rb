require 'acceptance/acceptance_helper.rb'

feature "Sing out", %q{
        In order to be shut down from system
        As an user
        I wont to be log out
                  } do

  given(:user) { create(:user) }

  scenario "Logged user try to sing out" do
    visit root_path
    sign_in(user)
    expect(page).to have_link("Sign out")
    click_on "Sign out"
    expect(page).to have_content("Signed out successfully.")
  end

  scenario "non-logged user try to sing out" do
    expect(page).to_not have_link("Sign out")
  end

end