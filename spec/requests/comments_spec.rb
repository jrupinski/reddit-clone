require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:existing_user) { create(:user) }
  let(:existing_post) { create(:post, author: existing_user) }
  let(:existing_comment) { create(:comment, author: existing_user, post_id: existing_post.id) }

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

  describe 'Voting' do
    describe 'POST #upvote' do
      context 'when logged in (as author or different user)' do
        # hacky login
        before(:each) do
          post session_path, params: { user: { username: existing_user.username, password: existing_user.password } }
        end

        context 'When not voted yet' do
          it 'adds upvote to comment' do
            expect(existing_comment.votes.count).to eq(0)
            expect(existing_comment.user_score).to eq(0)

            expect { post upvote_comment_path(existing_comment) }
              .to change { existing_comment.votes.count }.by(1)
              .and change { existing_comment.user_score }.by(1)

            expect(response).to redirect_to(existing_comment)
          end
        end

        context 'when user already voted removes vote' do
          it 'removes upvote from comment' do
            existing_comment.votes.create(user: existing_user, value: 1)
            expect(existing_comment.votes.count).to eq(1)
            expect(existing_comment.user_score).to eq(1)

            expect { post upvote_comment_path(existing_comment) }
              .to change { existing_comment.votes.count }.by(-1)
              .and change { existing_comment.user_score }.by(-1)

            expect(response).to redirect_to(existing_comment)
          end

          it 'removes downvote from comment' do
            existing_comment.votes.create(user: existing_user, value: -1)
            expect(existing_comment.votes.count).to eq(1)
            expect(existing_comment.user_score).to eq(-1)

            expect { post upvote_comment_path(existing_comment) }
              .to change { existing_comment.votes.count }.by(-1)
              .and change { existing_comment.user_score }.by(1)

            expect(response).to redirect_to(existing_comment)
          end
        end
      end

      context 'when not logged it' do
        it 'redirects to login page' do
          expect { post upvote_comment_path(existing_comment) }
            .to change { existing_comment.votes.count }.by(0)
            .and change { existing_comment.user_score }.by(0)

          expect(response).to redirect_to(new_session_path)
        end
      end
    end

    describe 'POST #downvote' do
      context 'when logged in (as author or different user)' do
        # hacky login
        before(:each) do
          post session_path, params: { user: { username: existing_user.username, password: existing_user.password } }
        end

        context 'When not voted yet' do
          it 'adds downvote to comment' do
            expect(existing_comment.votes.count).to eq(0)
            expect(existing_comment.user_score).to eq(0)

            expect { post downvote_comment_path(existing_comment) }
              .to change { existing_comment.votes.count }.by(1)
              .and change { existing_comment.user_score }.by(-1)

            expect(response).to redirect_to(existing_comment)
          end
        end

        context 'when user already voted removes vote' do
          it 'removes upwnvote from comment' do
            existing_comment.votes.create(user: existing_user, value: 1)
            expect(existing_comment.votes.count).to eq(1)
            expect(existing_comment.user_score).to eq(1)

            expect { post downvote_comment_path(existing_comment) }
              .to change { existing_comment.votes.count }.by(-1)
              .and change { existing_comment.user_score }.by(-1)

            expect(response).to redirect_to(existing_comment)
          end

          it 'removes downvote from comment' do
            existing_comment.votes.create(user: existing_user, value: -1)
            expect(existing_comment.votes.count).to eq(1)
            expect(existing_comment.user_score).to eq(-1)

            expect { post downvote_comment_path(existing_comment) }
              .to change { existing_comment.votes.count }.by(-1)
              .and change { existing_comment.user_score }.by(1)

            expect(response).to redirect_to(existing_comment)
          end
        end
      end

      context 'when not logged it' do
        it 'redirects to login page' do
          expect { post downvote_comment_path(existing_comment) }
            .to change { existing_comment.votes.count }.by(0)
            .and change { existing_comment.user_score }.by(0)

          expect(response).to redirect_to(new_session_path)
        end
      end
    end
  end
end
