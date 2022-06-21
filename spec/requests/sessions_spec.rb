require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'POST #create' do
    describe 'Creates a session for user' do
      let(:user) { create(:user) }

      context 'when valid credentials' do
        it 'logins user and redirects to his profile' do
          post session_path, params: { user: { username: user.username, password: user.password } }
          expect(response).to redirect_to(user_path(user))
        end
      end

      context 'when invalid credentials' do
        it 'redirects to login page' do
          post session_path, params: { user: { username: user.username, password: 'invalid_password' } }
          expect(response).to redirect_to(new_session_path)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'Ends a session for user' do
      before(:each) do
        user = create(:user, password: 'password')
        post session_path, params: { user: { username: user.username, password: user.password } }
      end

      it 'logouts user' do
        delete session_path
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
