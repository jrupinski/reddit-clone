class CommentsController < ApplicationController
  before_action :require_current_user!, only: %i[new create edit update destroy]
  before_action :require_author!, only: %i[edit update destroy]

  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @comment = Comment.new(post_id: params[:post_id])
  end

  def create
    @comment = current_user.comments.new(comment_params)

    if @comment.save
      flash[:notice] = ['Comment created!']
    else
      flash[:errors] = @comment.errors.full_messages
    end

    redirect_to post_path(@comment.post)
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update(comment_params)
      flash[:notice] = ['Comment updated!']
      redirect_to post_path(@comment.post)
    else
      flash[:errors] = @comment.errors.full_messages
      redirect_to edit_comment_path(@comment)
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    if @comment.destroy
      flash[:notice] = ['Comment deleted!']
      redirect_to post_path(@comment.post)
    else
      flash[:errors] = @comment.errors.full_messages
      redirect_to comment_path(@comment)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id, :parent_comment_id)
  end

  def require_author!
    comment = Comment.find(params[:id])
    redirect_to post_path(comment.post) unless current_user == comment.author
  end
end
