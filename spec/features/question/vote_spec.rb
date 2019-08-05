require 'rails_helper'

feature 'Authenticated user has the right to vote for the question', %q{
  In order to highlight the desired question
  Authenticated user
  Has the opportunity to vote for the question
}, js:true do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'up' do
      click_on 'Vote up'

      expect(page).to have_content '1'
    end

    scenario 'down' do
      click_on 'Vote down'

      expect(page).to have_content '-1'
    end

    scenario 'cannot voted twice' do
      click_on 'Vote up'
      expect(page).to_not have_link "Vote up"
      expect(page).to_not have_link "Vote down"
    end

    scenario 'delete own vote' do
      click_on 'Vote up'
      click_on 'Delete'

      expect(page).to have_link "Vote up"
      expect(page).to have_link "Vote down"
      expect(page).to have_content '0'
    end
  end

  scenario 'Notauthenticated user not voted' do
    visit question_path(question)

    expect(page).to_not have_link "Vote up"
    expect(page).to_not have_link "Vote down"
  end

  scenario 'The author cannot vote for his question' do
    sign_in(question.user)
    visit question_path(question)
    expect(page).to_not have_link "Vote up"
    expect(page).to_not have_link "Vote down"
  end
end
