class PostsController < ApplicationController
  before_action :require_current_user!, except: :show
  before_action :require_author!, only: %i[edit update destroy]

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      flash[:notice] = ['Post created!']
      redirect_to post_path(@post)
    else
      flash[:errors] = @post.errors.full_messages
      redirect_to new_post_path
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      flash[:notice] = ['Post updated!']
      redirect_to post_path(@post)
    else
      flash[:errors] = @post.errors.full_messages
      redirect_to edit_post_path(@post)
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.destroy
      flash[:notice] = ['Post deleted!']
      redirect_to user_path(current_user)
    else
      flash[:errors] = @post.errors.full_messages
      redirect_to post_path(@post)
    end
  end

  def upvote
    add_vote(value: 1)
  end

  def downvote
    add_vote(value: -1)
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :content, :user_id, sub_ids: [])
  end

  def require_author!
    post = Post.find(params[:id])
    redirect_to user_path(current_user) unless current_user == post.author
  end

  def add_vote(value:)
    @post = Post.find(params[:id])
    vote = @post.votes.find_or_initialize_by(user: current_user)

    if vote.persisted?
      vote.destroy
      flash[:notice] = ['Vote removed']
    elsif vote.update(value:)
      notice_value = (value.positive? ? 'Upvote' : 'Downvote')
      flash[:notice] = ["#{notice_value} saved!"]
    else
      flash[:errors] = vote.errors.full_messages
    end

    redirect_back(fallback_location: post_path(@post))
  end
end
