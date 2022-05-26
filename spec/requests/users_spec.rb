require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST #create' do
    context 'when logged in' do
      it 'creates a User and redirects to his profile' do
        new_user = build(:user)
        post users_path, params: { user: { username: new_user.username, email: new_user.email, password: new_user.password } }
        expect(response).to redirect_to(user_path(User.last))
      end
    end

    context 'when not logged it' do
      it 'redirects to login page' do
        new_user = build(:user)
        post users_path, params: { user: { username: new_user.username, email: new_user.email, password: new_user.password } }
        expect(response).to redirect_to(new_user_path)
      end
    end
  end

  describe 'PATCH #edit' do
    let(:user) { create(:user) }

    context 'when logged in' do
      it 'edits User and redirects to his profile' do
        patch user_path(user), params: { user: { username: user.username, email: user.email, password: user.password } }
        expect(response).to redirect_to(user_path(user))
      end
    end

    context 'when not logged it' do
      it 'redirects to login page' do
        patch user_path(user), params: { user: { username: user.username, email: user.email, password: user.password } }
        expect(response).to redirect_to(new_user_path)
      end
    end
  end
end
