require 'rails_helper'

feature 'User can see the list of rewards for the best answer', %q{
  To see the list of the best awards answers
  Author of best answer
  I would like to see a reward
}, js: true do

  given!(:author) { create(:user) }
  given!(:not_author) { create(:user) }

  scenario 'Author best answer can see award' do
    sign_in(author)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Award title', with: 'test award'
    attach_file 'Award picture', "#{Rails.root}/spec/rails_helper.rb"

    click_on 'Ask'

    fill_in 'answer_body', with: 'Answer body'
    click_on 'Add answer'
    click_on 'Mark as best'

    visit awards_path
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'test award'
  end

  scenario 'Not author best answer can not see award' do
    sign_in(author)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Award title', with: 'test award'
    attach_file 'Award picture', "#{Rails.root}/spec/rails_helper.rb"

    click_on 'Ask'

    fill_in 'answer_body', with: 'Answer body'
    click_on 'Add answer'
    click_on 'Mark as best'

    click_on 'Log out'
    sign_in(not_author)
    visit awards_path
    expect(page).to_not have_content 'Test question'
    expect(page).to_not have_content 'test award'
  end
end
