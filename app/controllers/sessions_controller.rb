class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(username: user_params[:username], password: user_params[:password])

    if @user
      login_user!(@user)
      redirect_to user_path(@user)
    else
      flash.now[:errors] = ['Invalid credentials']
      render :new
    end
  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to new_session_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :id)
  end
end
