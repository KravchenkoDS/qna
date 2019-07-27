require 'rails_helper'

feature 'Authenticated user can create answer', %q{
  To create a new answer
  As an authenticated user
  has the ability to write an answer on the question page
} do

  given(:user) {create(:user)}
  given(:question) {create(:question, user: user)}

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
    end

    scenario 'write answer' do
      visit question_path(question)
      fill_in 'answer_body', with: 'Answer body'
      click_on 'Add answer'

      expect(page).to have_content 'Answer body'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Answer body'
      end
    end

    scenario 'write answer with errors', js: true do
      visit question_path(question)
      click_on 'Add answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'adds a answer with attached files' do
      visit question_path(question)
      fill_in 'answer_body', with: 'Answer body'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Add answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

  end


  scenario 'Unauthenticated tries to add a answer' do
    visit question_path(question)
    click_on 'Add answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
