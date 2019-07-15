require 'rails_helper'

feature 'User can show list of question', %q{
  In order to find similar problem
  As an any user
  I'd like to be able to look the list of questions
} do
  given(:questions) { create_list(:question, 3) }
  scenario 'User show list of questions' do
    questions = Question.all

    visit questions_path
    questions.each do |q|
      expect(page).to have_content q.title
    end
  end
end
