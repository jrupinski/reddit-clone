require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:existing_user) { create(:user) }
  let(:sub) { create(:sub) }

  describe 'POST #create' do

    context 'when logged in' do
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: existing_user.username, password: existing_user.password } }
      end

      it 'redirects to created post' do
        new_post = build(:post)
        post posts_path, params: { post: { title: new_post.title, url: new_post.url, content: new_post.content, sub_id: sub.id } }
        expect(response).to redirect_to(post_path(Post.last))
        expect(Post.last.title).to eq(new_post.title)
      end
    end

    context 'when not logged it' do
      it 'redirects to login page' do
        new_post = build(:post)
        post posts_path, params: { post: { title: new_post.url, url: new_post.url, content: new_post.content, sub_id: sub.id } }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'PATCH #edit' do
    let(:existing_post) { create(:post, author: existing_user, sub:) }

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

      it 'Does not allow editing, redirects to sub#show' do
        patch post_path(existing_post), params: { post: { email: 'new_email@example.com' } }
        expect(response).to redirect_to(sub_path(sub))
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
    let(:existing_post) { create(:post, author: existing_user, sub:) }

    context 'when logged in as author' do
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: existing_user.username, password: existing_user.password } }
      end

      it 'deletes post and redirects to sub#show' do
        delete post_path(existing_post)
        expect(response).to redirect_to(sub_path(sub))
      end
    end

    context 'when logged in as a different user' do
      let(:different_user) { create(:user) }
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: different_user.username, password: different_user.password } }
      end

      it 'Does not delete post, redirects to sub#show' do
        delete post_path(existing_post)
        expect(response).to redirect_to(sub_path(sub))
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
