require 'rails_helper'

feature 'The author of the question may mark the best answer to your question.', %q{
  Choose the best answer
  As an author of question
  The ability to mark the answer as the best
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:own_question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: own_question) }

  scenario 'Unauthenticated can not mark answer as best' do
    visit question_path(question)

    expect(page).to_not have_link 'Mark as best'
  end

  context 'Authentication user', js: true do
    background do
      sign_in(user)
    end

    scenario 'Author of question can mark answer as best' do
      visit question_path(own_question)

      first('.mark-as-best').click
      first('.mark-as-best').click

      expect(page).to have_css('.best', count: 1)
    end

    scenario 'Author of question can mark other answer' do
      answers.first.update(best: true)
      visit question_path(own_question)
      first('.mark-as-best').click

      expect(page).to have_css('.best', count: 1)
    end

    scenario 'Not author can not mark answer as best' do
      visit question_path(question)

      expect(page).to_not have_link 'Mark as best'
    end
  end
end
