class ApplicationController < ActionController::Base
  helper_method :current_user

  def login_user!(user)
    @current_user = user
    session[:session_token] = user.session_token
  end

  def current_user
    @current_user || User.find_by(session_token: session[:session_token])
  end

  # filters for before_action
  def require_current_user!
    redirect_to new_session_path unless current_user
  end

  def require_no_current_user!
    redirect_to user_path(current_user) if current_user
  end
end
