require "rails_helper"

feature "Show question and answers question", %q{
        In order to show answers for question
        As an user or guest
        I want to be able open question
                                                 } do

  given(:question) { create(:question) }
  before { create_list(:answer, 3, question: question) }

  scenario "show question and answers" do
    visit questions_path
    click_on "Test string 15 length"
    expect(page).to have_content "Test string 15 length" #question title
    expect(page).to have_content "Test body Test body Test body " #question body
    expect(page).to have_content "Test big body for answer for question", count: 3 #answers body
  end

end