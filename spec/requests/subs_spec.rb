require 'rails_helper'

RSpec.describe "Subs", type: :request do
  let(:existing_user) { create(:user) }

  describe 'POST #create' do
    context 'when logged in' do
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: existing_user.username, password: existing_user.password } }
      end

      it 'redirects to created sub' do
        new_sub = build(:sub)
        post subs_path, params: { sub: { name: new_sub.name, description: new_sub.description } }
        expect(response).to redirect_to(sub_path(Sub.last))
        expect(Sub.last.name).to eq(new_sub.name)
      end
    end

    context 'when not logged it' do
      it 'redirects to login page' do
        new_sub = build(:sub)
        post subs_path, params: { sub: { name: new_sub.name, description: new_sub.description } }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'PATCH #edit' do
    let(:existing_sub) { create(:sub, moderator: existing_user) }

    context 'when logged in as moderator' do
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: existing_user.username, password: existing_user.password } }
      end

      it 'edits sub and redirects to his profile' do
        patch sub_path(existing_sub), params: { sub: { email: 'new_email@example.com' } }
        expect(response).to redirect_to(sub_path(existing_sub))
      end
    end

    context 'when logged in as a different user' do
      let(:different_user) { create(:user) }
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: different_user.username, password: different_user.password } }
      end

      it 'Does not allow editing, redirects to subs index' do
        patch sub_path(existing_sub), params: { sub: { email: 'new_email@example.com' } }
        expect(response).to redirect_to(subs_path)
      end
    end

    context 'when not logged it' do
      it 'redirects to login page' do
        patch sub_path(existing_sub), params: { sub: { email: 'new_email@example.com' } }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:existing_sub) { create(:sub, moderator: existing_user) }

    context 'when logged in as moderator' do
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: existing_user.username, password: existing_user.password } }
      end

      it 'deletes sub and redirects to subs index' do
        delete sub_path(existing_sub)
        expect(response).to redirect_to(subs_path)
      end
    end

    context 'when logged in as a different user' do
      let(:different_user) { create(:user) }
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: different_user.username, password: different_user.password } }
      end

      it 'Does not delete sub, redirects to subs index' do
        delete sub_path(existing_sub)
        expect(response).to redirect_to(subs_path)
      end
    end

    context 'when not logged it' do
      it 'redirects to login page' do
        delete sub_path(existing_sub)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
