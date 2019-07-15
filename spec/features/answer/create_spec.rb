require 'rails_helper'

feature 'Authenticated user can create answer', %q{
  To create a new answer
  As an authenticated user
  has the ability to write an answer on the question page
} do

  given(:user) {create(:user)}
  given(:question) {create(:question, user: user)}

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'write answer' do
      visit question_path(question)
      fill_in 'answer_body', with: 'Answer body'
      click_on 'Add answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Answer body'
    end

    scenario 'write answer with errors' do
      visit question_path(question)
      click_on 'Add answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated tries to add a answer' do
    visit question_path(question)
    click_on 'Add answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
