require 'rails_helper'

feature 'User can register', %q{
  To ask questions
  As unregistered user
  Need to register
} do

  background {visit new_user_registration_path}

  scenario 'Unregistered user tries to register' do
    fill_in 'Email', with: 'good_user@domain.com'
    fill_in 'Password', with: 'dsfdfsfsf7777'
    fill_in 'Password confirmation', with: 'dsfdfsfsf7777'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to register with errors' do
    fill_in 'Email', with: 'bad@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'Registered user tries to register' do
    fill_in 'Email', with: 'good@domain.com'
    fill_in 'Password', with: 'pass123'
    fill_in 'Password confirmation', with: 'pass123'
    click_on 'Sign up'
    click_on 'Log out'
    visit new_user_registration_path
    fill_in 'Email', with: 'good@domain.com'
    fill_in 'Password', with: 'pass123'
    fill_in 'Password confirmation', with: 'pass123'
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
