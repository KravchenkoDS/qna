require 'rails_helper'

feature 'Author may delete own answer', %q{
  To remove the answer with an error
  Authenticated user
  has the ability to delete the answer
} do

  given(:users) {create_list(:user, 2)}
  given!(:answer) {create(:answer, user: users.first, question: question)}
  given!(:question) {create(:question)}

  scenario 'Author delete answer' do
    sign_in(users.first)
    visit question_path(question)
    save_and_open_page
    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
  end

  scenario 'Not author tried delete answer' do
    sign_in(users.last)
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Not authenticated user tried delete answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end
