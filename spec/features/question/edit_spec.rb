require 'rails_helper'

feature 'User edit question', %q{
  The author of the question can correct errors
  I would not want to edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:own_question) { create(:question, user: user) }

  scenario 'Unauthenticated can not edit question' do
    visit questions_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Author', js: true do
    background do
      sign_in user

      visit question_path(own_question)
    end

    scenario 'edits his question' do

      within '.question-link' do
        click_on 'Edit'

        fill_in 'Edit question', with: 'edited question'

        click_on 'Save'

        expect(page).to_not have_content own_question.body

        expect(page).to_not have_selector 'textarea'
      end
      within '.question' do
        expect(page).to have_content 'edited question'
      end
    end

    scenario 'edits his question with errors' do

      within '.question-link' do
        click_on 'Edit'

        fill_in 'Edit question', with: ''

        click_on 'Save'
      end
      expect(page).to have_content own_question.body

      expect(page).to have_selector 'input'

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question" do
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
