require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:existing_user) { create(:user) }

  describe 'POST #create' do
    context 'when logged in' do
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: existing_user.username, password: existing_user.password } }
      end

      it 'redirects to user profile' do
        new_user = build(:user)
        post users_path, params: { user: { username: new_user.username, email: new_user.email, password: new_user.password } }
        expect(response).to redirect_to(user_path(existing_user))
      end
    end

    context 'when not logged it' do
      it 'creates a User and redirects to his profile' do
        new_user = build(:user)
        post users_path, params: { user: { username: new_user.username, email: new_user.email, password: new_user.password } }
        expect(response).to redirect_to(user_path(User.last))
      end
    end
  end

  describe 'PATCH #edit' do
    let(:user) { create(:user) }

    context 'when logged in' do
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: existing_user.username, password: existing_user.password } }
      end

      it 'edits User and redirects to his profile' do
        patch user_path(existing_user), params: { user: { email: 'new_email@example.com' } }
        expect(response).to redirect_to(user_path(existing_user))
      end
    end

    context 'when not logged it' do
      it 'redirects to login page' do
        patch user_path(user), params: { user: { username: user.username, email: user.email, password: user.password } }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
