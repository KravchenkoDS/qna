require 'rails_helper'

feature 'Only author may delete files from own question', %q{
  To delete files, etc.
  Authenticated user - author's question
  I would like to delete files from quesrion
} do

  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users.first) }

  background do
    question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
  end

  scenario 'Not authenticated user tried delete file', js: true do
    visit question_path(question)

    expect(page).to_not have_link "Delete file"
  end

  scenario 'Author delete file', js: true do
    sign_in(users.first)
    visit question_path(question)
    click_on 'Delete file'

    expect(page).to_not have_content 'rails_helper.rb'
  end

  scenario 'Not author tried delete file' do
    sign_in(users.last)
    visit question_path(question)

    expect(page).to_not have_link "Delete file"
  end
end
