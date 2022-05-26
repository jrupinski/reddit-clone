require 'rails_helper'

RSpec.describe 'Users', type: :feature do
  let(:new_user) { build(:user) }
  let(:existing_user) { create(:user) }

  context 'signing up users' do
    it 'has a new user form page' do
      visit new_user_path
      expect(page).to have_content 'Sign up'
      expect(page).to have_field 'Username'
      expect(page).to have_field 'Email'
      expect(page).to have_field 'Password'
      expect(page).to have_button 'Create'
    end

    context 'valid credentials' do
      it 'creates a new user' do
        sign_up_user(username: new_user.username)
        expect(page).to have_content 'User profile'
        expect(page).to have_content new_user.username
      end
    end

    context 'invalid credentials' do
      it 'redirect to Sign up page with an error' do
        sign_up_user(username: existing_user.username)
        expect(page).to have_content 'Sign up'
        expect(page).to have_content 'Username has already been taken'
      end
    end
  end

  context 'logging in user' do
    it 'has a user login form page' do
      visit new_session_path
      expect(page).to have_content 'Log in'
      expect(page).to have_field 'Username'
      expect(page).to have_field 'Password'
      expect(page).to have_button 'Log in'
    end

    context 'valid credentials' do
      it 'creates a new sesson for user' do
        log_in_user(username: existing_user.username)
        expect(page).to have_content 'User profile'
        expect(page).to have_content existing_user.username
      end
    end

    context 'invalid credentials' do
      it 'redirect to Log in page with an error' do
        log_in_user(username: new_user.username)
        expect(page).to have_content 'Log in'
        expect(page).to have_content 'Invalid credentials'
      end
    end
  end
end
