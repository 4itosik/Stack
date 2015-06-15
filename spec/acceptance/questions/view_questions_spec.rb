require 'acceptance/acceptance_helper.rb'

feature 'View questions', %q{
        In order to read question
        As an user or guest
        I want to be able see all questions
                                 } do

  before { create_list(:question, 3) }

  scenario "view lists of question" do
    visit questions_path
    expect(page).to have_content "Test string 15 length", count: 3 #answer title
    expect(page).to have_content "Test body Test body Test body ", count: 3 #answer body
  end

end