require 'rails_helper'

feature 'User can show a question with list of answer', %q{
  To see all suggested answers to the question
  As an any user
  I'd like to be able to look the list of answer on the question page
} do
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'User show question with list of answers' do
    visit question_path(question)

    expect(page).to have_content question.body
    expect(page).to have_content question.title

    answers.each do |a|
      expect(page).to have_content a.body
    end
  end
end
