require "acceptance/acceptance_helper"

feature "Best answer", %q{
        In order to mark best answer
        As an order question
        I want to be able select best answer
                     } do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }
  given!(:best_answer) { create(:answer, question: question, best: true) }
  given!(:other_answer) { create(:answer, question: question) }

  given(:non_owner) { create(:user) }

  describe "Owner question" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "sees link to select best answer" do
      within "#answer_#{answer.id}" do
        expect(page).to have_link "Выбрать лучшим"
      end
    end

    scenario "Try select best answer", js: true do
      within "#answer_#{answer.id}" do
        click_on "Выбрать лучшим"
        expect(page).to have_link "Отменить лучший ответ"
      end
    end

    scenario "sees link cancel select best answer", js: true do
      within "#answer_#{best_answer.id}" do
        expect(page).to have_link "Отменить лучший ответ"
      end
    end

    scenario "Try cancel select best answer", js: true do
      within "#answer_#{best_answer.id}" do
        click_on "Отменить лучший ответ"
        expect(page).to have_link "Выбрать лучшим"
      end
    end

    scenario "Try select only one best answer", js: true do
      within "#answer_#{answer.id}" do
        click_on "Выбрать лучшим"
      end
      within "#answer_#{best_answer.id}" do
        click_on "Выбрать лучшим"
      end
      within "#answer_#{answer.id}" do
        expect(page).to have_link "Выбрать лучшим"
      end
      within "#answer_#{best_answer.id}" do
        expect(page).to have_content "Отменить лучший ответ"
      end
    end
  end

  describe "Non owner question" do
    before do
      sign_in(non_owner)
      visit question_path(question)
    end

    scenario "Try select best answer" do
      within "#answer_#{answer.id}" do
        expect(page).to_not have_link "Выбрать лучшим"
      end
    end

    scenario "Try cancel select best answer", js: true do
      within "#answer_#{answer.id}" do
        expect(page).to_not have_link "Выбрать лучшим"
      end
      within "#answer_#{best_answer.id}" do
        expect(page).to_not have_content "Отменить лучший ответ"
      end
    end
  end

  scenario "sorting answers" do
    sign_in(user)
    visit question_path(question)
    within "div.answer:nth-of-type(1)" do
      expect(page).to have_content best_answer.body
    end
    within "div.answer:nth-of-type(2)" do
      expect(page).to have_content answer.body
    end
    within "div.answer:nth-of-type(3)" do
      expect(page).to have_content other_answer.body
    end
  end

end