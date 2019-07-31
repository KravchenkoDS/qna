require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:invalid_url) { 'rbc_o.ru' }
  given(:google_url) { 'https://google.com' }
  given(:gist_url) { 'https://gist.github.com/KravchenkoDS/6a2970b1d11897016737dbd24c566431' }
  given(:question) { create(:question, user: user) }

  scenario 'User adds links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Title question'
    fill_in 'Body', with: 'text text text'

    click_on 'add link'

    fill_in 'Link name', with: 'Gist'
    fill_in 'Url', with: gist_url

    click_on 'add link'

    fill_in  'Link name', with: 'Google', currently_with: ''
    fill_in 'Url', with: google_url, currently_with: ''

    click_on 'Ask'

    expect(page).to have_content 'test.txt'
    expect(page).to have_link 'google', href: google_url
  end

  scenario 'User adds links with invalid url', js: true do
    sign_in(user)
    visit new_question_path

    click_on 'add link'

    fill_in 'Link name', with: 'Bad url'
    fill_in 'Url', with: invalid_url

    click_on 'Ask'

    expect(page).to have_content 'Links url is not a valid URL'
  end

  scenario 'edits a question with adds link', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question-link' do
      click_on 'Edit'
      click_on 'add link'
      fill_in 'Link name', with: 'google'
      fill_in 'Url', with: google_url
      click_on 'Save'
    end
    expect(page).to have_link 'google', href: google_url
  end
end
