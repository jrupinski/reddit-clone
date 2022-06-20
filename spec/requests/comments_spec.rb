require 'rails_helper'

RSpec.describe "Comments", type: :request do
require 'rails_helper'
  let(:existing_user) { create(:user) }
  let(:existing_post) { create(:post, author: existing_user) }

  describe 'POST #create' do
    context 'when logged in' do
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: existing_user.username, password: existing_user.password } }
      end

      it 'redirects to parent post after creating comment' do
        new_comment = build(:comment)
        post comments_path, params: { comment: { content: new_comment.content, post_id: existing_post.id } }
        expect(response).to redirect_to(post_path(existing_post))
        expect(existing_post.comments.count).to eq 1
        expect(existing_post.comments.last.content).to eq new_comment.content
      end
    end

    context 'when not logged it' do
      it 'redirects to login page' do
        new_comment = build(:comment)
        post comments_path, params: { comment: { content: new_comment.content, post_id: existing_post.id } }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'PATCH #edit' do
    let(:existing_comment) { create(:comment, author: existing_user, post_id: existing_post.id) }

    # let(:existing_comment) { create(:comment, author: existing_user) }

    context 'when logged in as author' do
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: existing_user.username, password: existing_user.password } }
      end

      it 'edits comment and redirects to his profile' do
        updated_comment = build(:comment)
        patch comment_path(existing_comment), params: { comment: { content: updated_comment.content } }
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
        updated_comment = build(:comment)
        # debugger
        patch comment_path(existing_comment), params: { comment: { content: updated_comment.content } }
        expect(response).to redirect_to(post_path(existing_post))
      end
    end

    context 'when not logged it' do
      it 'redirects to login page' do
        updated_comment = build(:comment)
        patch comment_path(existing_comment), params: { comment: { content: updated_comment.content } }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:existing_comment) { create(:comment, author: existing_user, post_id: existing_post.id) }

    context 'when logged in as author' do
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: existing_user.username, password: existing_user.password } }
      end

      it 'deletes comment and redirects to user profile' do
        delete comment_path(existing_comment)
        expect(response).to redirect_to(post_path(existing_post))
      end
    end

    context 'when logged in as a different user' do
      let(:different_user) { create(:user) }
      # hacky login
      before(:each) do
        post session_path, params: { user: { username: different_user.username, password: different_user.password } }
      end

      it 'Does not delete comment, redirects to user profile' do
        delete comment_path(existing_comment)
        expect(response).to redirect_to(post_path(existing_post))
      end
    end

    context 'when not logged it' do
      it 'redirects to login page' do
        delete comment_path(existing_comment)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
