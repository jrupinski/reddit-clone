require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:existing_user) { create(:user) }
  let(:subs) { create_list(:sub, 3) }
  let(:existing_post) { create(:post, author: existing_user, sub_ids: subs.pluck(:id)) }

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

  describe 'Voting' do
    describe 'POST #upvote' do
      context 'when logged in (as author or different user)' do
        # hacky login
        before(:each) do
          post session_path, params: { user: { username: existing_user.username, password: existing_user.password } }
        end

        context 'When not voted yet' do
          it 'adds upvote to post' do
            expect(existing_post.votes.count).to eq(0)
            expect(existing_post.user_score).to eq(0)

            expect { post upvote_post_path(existing_post) }
              .to change { existing_post.votes.count }.by(1)
              .and change { existing_post.user_score }.by(1)

            expect(response).to redirect_to(existing_post)
          end
        end

        context 'when user already voted removes vote' do
          it 'removes upvote from post' do
            existing_post.votes.create(user: existing_user, value: 1)
            expect(existing_post.votes.count).to eq(1)
            expect(existing_post.user_score).to eq(1)

            expect { post upvote_post_path(existing_post) }
              .to change { existing_post.votes.count }.by(-1)
              .and change { existing_post.user_score }.by(-1)

            expect(response).to redirect_to(existing_post)
          end

          it 'removes downvote from post' do
            existing_post.votes.create(user: existing_user, value: -1)
            expect(existing_post.votes.count).to eq(1)
            expect(existing_post.user_score).to eq(-1)

            expect { post upvote_post_path(existing_post) }
              .to change { existing_post.votes.count }.by(-1)
              .and change { existing_post.user_score }.by(1)

            expect(response).to redirect_to(existing_post)
          end
        end
      end

      context 'when not logged it' do
        it 'redirects to login page' do
          expect { post upvote_post_path(existing_post) }
            .to change { existing_post.votes.count }.by(0)
            .and change { existing_post.user_score }.by(0)

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
          it 'adds downvote to post' do
            expect(existing_post.votes.count).to eq(0)
            expect(existing_post.user_score).to eq(0)

            expect { post downvote_post_path(existing_post) }
              .to change { existing_post.votes.count }.by(1)
              .and change { existing_post.user_score }.by(-1)

            expect(response).to redirect_to(existing_post)
          end
        end

        context 'when user already voted removes vote' do
          it 'removes upwnvote from post' do
            existing_post.votes.create(user: existing_user, value: 1)
            expect(existing_post.votes.count).to eq(1)
            expect(existing_post.user_score).to eq(1)

            expect { post downvote_post_path(existing_post) }
              .to change { existing_post.votes.count }.by(-1)
              .and change { existing_post.user_score }.by(-1)

            expect(response).to redirect_to(existing_post)
          end

          it 'removes downvote from post' do
            existing_post.votes.create(user: existing_user, value: -1)
            expect(existing_post.votes.count).to eq(1)
            expect(existing_post.user_score).to eq(-1)

            expect { post downvote_post_path(existing_post) }
              .to change { existing_post.votes.count }.by(-1)
              .and change { existing_post.user_score }.by(1)

            expect(response).to redirect_to(existing_post)
          end
        end
      end

      context 'when not logged it' do
        it 'redirects to login page' do
          expect { post downvote_post_path(existing_post) }
            .to change { existing_post.votes.count }.by(0)
            .and change { existing_post.user_score }.by(0)

          expect(response).to redirect_to(new_session_path)
        end
      end
    end
  end
end
