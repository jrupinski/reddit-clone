require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:existing_user) { create(:user) }
  let(:subs) { create_list(:sub, 3) }

  describe 'POST #create' do
    context 'when logged in' do
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: existing_user.username, password: existing_user.password } }
      end

      it 'redirects to created post' do
        new_post = build(:post)
        post posts_path, params: { post: { title: new_post.title, url: new_post.url, content: new_post.content, sub_ids: subs.pluck(:id) } }
        expect(response).to redirect_to(post_path(Post.last))
        expect(Post.last.title).to eq(new_post.title)
      end
    end

    context 'when not logged it' do
      it 'redirects to login page' do
        new_post = build(:post)
        post posts_path, params: { post: { title: new_post.url, url: new_post.url, content: new_post.content, sub_ids: subs.pluck(:id) } }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'PATCH #edit' do
    let(:existing_post) { create(:post, author: existing_user, sub_ids: subs.pluck(:id)) }

    context 'when logged in as author' do
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: existing_user.username, password: existing_user.password } }
      end

      it 'edits post and redirects to his profile' do
        patch post_path(existing_post), params: { post: { email: 'new_email@example.com' } }
        expect(response).to redirect_to(post_path(existing_post))
      end
    end

    context 'when logged in as a different user' do
      let(:different_user) { create(:user) }
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: different_user.username, password: different_user.password } }
      end

      it 'Does not allow editing, redirects to user profile' do
        patch post_path(existing_post), params: { post: { email: 'new_email@example.com' } }
        expect(response).to redirect_to(user_path(different_user))
      end
    end

    context 'when not logged it' do
      it 'redirects to login page' do
        patch post_path(existing_post), params: { post: { email: 'new_email@example.com' } }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:existing_post) { create(:post, author: existing_user, sub_ids: subs.pluck(:id)) }

    context 'when logged in as author' do
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: existing_user.username, password: existing_user.password } }
      end

      it 'deletes post and redirects to user profile' do
        delete post_path(existing_post)
        expect(response).to redirect_to(user_path(existing_user))
      end
    end

    context 'when logged in as a different user' do
      let(:different_user) { create(:user) }
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: different_user.username, password: different_user.password } }
      end

      it 'Does not delete post, redirects to user profile' do
        delete post_path(existing_post)
        expect(response).to redirect_to(user_path(different_user))
      end
    end

    context 'when not logged it' do
      it 'redirects to login page' do
        delete post_path(existing_post)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
