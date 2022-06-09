class PostsController < ApplicationController
  before_action :require_current_user!, only: %i[new create edit update destroy]
  before_action :require_author!, only: %i[edit update destroy]

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.sub = Sub.find(post_params[:sub_id])
    @post.author = current_user

    if @post.save
      redirect_to post_path(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
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
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.destroy
      flash[:notice] = 'Post deleted!'
      redirect_to sub_path(@post.sub)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :show
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :content, :sub_id)
  end

  def require_author!
    post = Post.find(params[:id])
    redirect_to sub_path(post.sub) unless current_user == post.author
  end
end
