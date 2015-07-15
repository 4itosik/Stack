require 'acceptance/acceptance_helper'

feature "Add file to question", %q{
        In order to illustrate my question
        As an question's owner
        I want to be able add to attach files
                              } do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario "Add files to question", js: true do
    fill_in 'Title', with: "Test string 15 length"
    fill_in "Body", with: "Test body Test body Test body "

    click_on "Еще файл"
    click_on "Еще файл"

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/public/robots.txt")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")

    click_on "Add question"

    expect(page).to have_link "robots.txt"
    expect(page).to have_link "rails_helper.rb"
  end

end