require 'rails_helper'

feature 'Only author may delete links from own question', %q{
  In order delete not rigth links etc
  As an authenticated user - author question
  I'd like to be able delete links from question
} do

  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users.first) }
  given!(:link) { question.links.create!(name: 'google', url: 'https://www.google.com') }

  scenario 'Not authenticated user tried delete link', js: true do
    visit question_path(question)

    expect(page).to_not have_link "Delete link"
  end

  scenario 'Author delete link', js: true do
    sign_in(users.first)
    visit question_path(question)
    click_on 'Delete link'

    expect(page).to_not have_link 'google', href: link.url
  end

  scenario 'Not author tried delete link' do
    sign_in(users.last)
    visit question_path(question)

    expect(page).to_not have_link "Delete link"
  end
end
