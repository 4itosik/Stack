require 'acceptance/acceptance_helper'

feature "Delete files", %q{
        In order to accidentally remove added files from answer
        As an attachment's owner
        I want to be able delete attachment
                      } do


  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, user: user, question: question) }
  given!(:attachment) { create(:attachment, attachable: answer) }
  given(:other_user) { create(:user) }

  describe "Authenticated owner user" do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "have link to delete attachment" do
      within ".answers" do
        expect(page).to have_link "Delete attachment"
      end
    end


    scenario "try to delete attachment from question", js: true do
      within ".answers" do
        click_on "Delete attachment"
        expect(page).to_not have_link attachment.file.identifier
      end
    end
  end

  scenario "Authenticated non-owner user try to delete attachment from question" do
    sign_in(other_user)
    visit question_path(question)
    within ".answers" do
      expect(page).to_not have_link "Delete attachment"
    end
  end

  scenario "non-authenticated try to delete attachment from question" do
    visit question_path(question)
    within ".answers" do
      expect(page).to_not have_link "Delete attachment"
    end
  end

end