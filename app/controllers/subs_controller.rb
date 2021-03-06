class SubsController < ApplicationController
  before_action :require_current_user!, only: %i[new create edit update destroy]
  before_action :require_moderator!, only: %i[edit update destroy]

  def index
    @subs = Sub.all.page params[:page]
    render :index
  end

  def show
    @sub = Sub.friendly.find(params[:id])
    @posts = @sub.posts_sorted_by_user_score.page params[:page]

    render :show
  end

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = current_user.subs.new(sub_params)

    if @sub.save
      flash[:notice] = ['Sub created!']
      redirect_to sub_path(@sub)
    else
      flash[:errors] = @sub.errors.full_messages
      redirect_to new_sub_path
    end
  end

  def edit
    @sub = Sub.friendly.find(params[:id])
  end

  def update
    @sub = Sub.friendly.find(params[:id])

    if @sub.update(sub_params)
      flash[:notice] = ['Sub updated!']
      redirect_to sub_path(@sub)
    else
      flash[:errors] = @sub.errors.full_messages
      redirect_to edit_sub_path(@sub)
    end
  end

  def destroy
    @sub = Sub.friendly.find(params[:id])

    if @sub.destroy
      flash[:notice] = ['Sub deleted!']
      redirect_to subs_path
    else
      flash[:errors] = @sub.errors.full_messages
      redirect_to sub_path(@sub)
    end
  end

  private

  def sub_params
    params.require(:sub).permit(:name, :description, :moderator_id)
  end

  def require_moderator!
    sub = Sub.friendly.find(params[:id])
    redirect_to subs_path unless current_user == sub.moderator
  end
end
