class CommentsController < ApplicationController
  before_action :require_current_user!, only: %i[new create edit update destroy]
  before_action :require_author!, only: %i[edit update destroy]

  def new
    post = Post.find(params[:post_id])
    @comment = post.comments.new
  end

  def create
    @comment = current_user.comments.new(comment_params)

    if @comment.save
      redirect_to post_path(@comment.post)
    else
      flash.now[:errors] = @comment.errors.full_messages
      render :new
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update(comment_params)
      redirect_to post_path(@comment.post)
    else
      flash.now[:errors] = @comment.errors.full_messages
      render :edit
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    if @comment.destroy
      flash[:notice] = 'Comment deleted!'
      redirect_to post_path(@comment.post)
    else
      flash.now[:errors] = @comment.errors.full_messages
      render :show
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end

  def require_author!
    comment = Comment.find(params[:id])
    redirect_to post_path(comment.post) unless current_user == comment.author
  end
end
