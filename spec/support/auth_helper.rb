module AuthHelper
  def sign_up_user(username:)
    visit new_user_path
    fill_in 'Username', with: username
    fill_in 'Email', with: Faker::Internet.email
    fill_in 'Password', with: 'password'
    click_button 'Create'
  end

  def log_in_user(username:)
    visit new_session_path
    fill_in 'Username', with: username
    fill_in 'Password', with: 'password'
    click_button 'Log in'
  end
end
