require 'acceptance/acceptance_helper'

feature "Add file to answer", %q{
        In order to illustrate my answer
        As an question's owner
        I want to be able add to attach files
                              } do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario "Add files to answer", js: true do
    within '#answer-form' do
      fill_in "Body", with: "Test asnwer body Test body Test body "

      click_on "Еще файл"

      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/public/robots.txt")
      inputs[1].set("#{Rails.root}/spec/rails_helper.rb")

      click_on  "Save answer"
    end

    within '.answers' do
      expect(page).to have_link "robots.txt"
      expect(page).to have_link "rails_helper.rb"
    end
  end

end