class PostsController < ApplicationController
  before_action :require_current_user!, only: %i[new create edit update destroy]
  before_action :require_author!, only: %i[edit update destroy]

  def show
    @post = Post.find(params[:id])
    @all_comments = @post.comments.includes(:author)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
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
      redirect_to post_path(@post)
    else
      flash[:errors] = @post.errors.full_messages
      redirect_to edit_post_path(@post)
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.destroy
      flash[:notice] = 'Post deleted!'
      redirect_to user_path(current_user)
    else
      flash[:errors] = @post.errors.full_messages
      redirect_to post_path(@post)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :content, :user_id, sub_ids: [])
  end

  def require_author!
    post = Post.find(params[:id])
    redirect_to user_path(current_user) unless current_user == post.author
  end
end
