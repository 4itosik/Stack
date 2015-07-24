require 'acceptance/acceptance_helper.rb'

feature "Sign in Twitter", %q{
        In order to be able login without email and password
        As an user
        I want to be able sign in from Twitter
                          } do

  background { visit new_user_session_path }

  describe "Existing user try to sign" do

    context "if user not have authorization" do
      scenario "sign in" do
        expect(page).to have_link "Sign in with Twitter"

        mock_auth_hash(:twitter, nil)

        click_on "Sign in with Twitter"

        expect(page).to have_content "Введите Ваш email, для авторизации через Twitter"

        fill_in "Email", with: "test@user.ru"
        click_on "Подтвердить"

        open_email('test@user.ru')

        expect(current_email).to have_content 'Ссылке'

        current_email.click_on "Ссылке"

        expect(page).to_not have_link "Login"
        expect(page).to have_link "Sign out"
      end
    end

    context "if user have authorization" do
      let(:user) { create(:user) }
      let(:authorization) { create(:authorization, user: user, provider: "twitter", uid: "12345") }

      scenario "sign in" do
        expect(page).to have_link "Sign in with Twitter"

        mock_auth_hash(:twitter)

        click_on "Sign in with Twitter"

        expect(page).to have_content "Successfully authenticated from Twitter account."
        expect(page).to_not have_link "Login"
        expect(page).to have_link "Sign out"
      end
    end

  end
end