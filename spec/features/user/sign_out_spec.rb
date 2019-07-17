require 'rails_helper'

feature 'User can sign out', %q{
  To close the session
  As authenticated user
  I would like to be able to complete the session
} do

  given(:user) {create(:user)}

  scenario 'Registered user tries to sign out' do
    visit root_path
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
