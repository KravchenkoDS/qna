require 'rails_helper'

feature 'Authenticated user has the right to vote for the answer', %q{
  In order to highlight the desired answer
  Authenticated user
  Has the opportunity to vote for the answer
}, js:true do

  given(:user) { create(:user) }
  given!(:answer) { create(:answer) }

  describe 'authenticated user' do
    background do
      sign_in(user)
      visit question_path(answer.question)
    end
    scenario 'up' do
      within '.answers' do
        click_on 'Vote up'

        expect(page).to have_content '1'
      end
    end

    scenario 'down' do
      within '.answers' do
        click_on 'Vote down'

        expect(page).to have_content '-1'
      end
    end

    scenario 'cannot voted twice' do
      within '.answers' do
        click_on 'Vote up'

        expect(page).to_not have_link "Vote up"
        expect(page).to_not have_link "Vote down"
      end
    end

    scenario 'delete own vote' do
      within '.answers' do
        click_on 'Vote up'
        click_on 'Delete'

        expect(page).to have_link "Vote up"
        expect(page).to have_link "Vote down"
        expect(page).to have_content '0'
      end
    end
  end

  scenario 'Notauthenticated user not voted' do
    visit question_path(answer.question)
    within '.answers' do
      expect(page).to_not have_link "Vote up"
      expect(page).to_not have_link "Vote down"
    end
  end

  scenario 'The author cannot vote for his question' do
    sign_in(answer.user)
    visit question_path(answer.question)
    within '.answers' do
      expect(page).to_not have_link "Vote up"
      expect(page).to_not have_link "Vote down"
    end
  end
end
