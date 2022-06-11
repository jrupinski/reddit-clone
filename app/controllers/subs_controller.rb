class SubsController < ApplicationController
  before_action :require_current_user!, only: %i[new create edit update destroy]
  before_action :require_moderator!, only: %i[edit update destroy]

  def index
    @subs = Sub.all
    render :index, locals: { subs: @subs}
  end

  def show
    @sub = Sub.find(params[:id])
    posts = @sub.posts

    render :show, locals: { posts:, sub: @sub }
  end

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = current_user.subs.new(sub_params)

    if @sub.save
      redirect_to sub_path(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit
    @sub = Sub.find(params[:id])
  end

  def update
    @sub = Sub.find(params[:id])

    if @sub.update(sub_params)
      redirect_to sub_path(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def destroy
    @sub = Sub.find(params[:id])

    if @sub.destroy
      flash[:notice] = 'Sub deleted!'
      redirect_to subs_path
    else
      flash.now[:errors] = @sub.errors.full_messages
      redirect_to sub_path(@sub)
    end
  end

  private

  def sub_params
    params.require(:sub).permit(:title, :description, :moderator_id)
  end

  def require_moderator!
    sub = Sub.find(params[:id])
    redirect_to subs_path unless current_user == sub.moderator
  end
end
