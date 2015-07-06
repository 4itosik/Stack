require 'acceptance/acceptance_helper.rb'

feature "Edit and update answer", %q{
         In order to edit answer
         As an user
         I want to be able owner this answer
                          } do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:other_user) { create(:user) }

  scenario "Owner user try to edit answer", js: true do
    sign_in(user)
    visit question_path(question)
    click_on "Edit answer"
    within ".answers" do
      fill_in "Body", with: "New test big body for answer..."
    end
    click_on "Update answer"
    within "#answer_#{answer.id}" do
      expect(page).to have_content "New test big body for answer..."
    end
  end

  scenario "non-owner user try to edit question", js: true do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to_not have_content "Edit answer"
  end

  scenario "Owner user try to edit answer with invalid attributes", js: true do
    sign_in(user)
    visit question_path(question)

    click_on "Edit answer"
    within ".answers" do
      fill_in "Body", with: "Small bady"
    end
    click_on "Update answer"

    within "#answer_#{answer.id}" do
      expect(page).to have_content "Test big body for answer"
    end
    within "#answer_#{answer.id} form" do
      expect(page).to have_content "1 error prohibited this answer from being saved:"
    end
  end

end