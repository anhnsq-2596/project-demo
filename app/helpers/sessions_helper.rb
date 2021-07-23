module SessionsHelper
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find(user_id) 
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    if logged_in?
      session.delete(:user_id)
      @current_user = nil
    end
  end

  def validate_login
    unless logged_in?
      flash[:danger] = t("commons.login_required")      
      redirect_to login_url
    end
  end

  def authorized_with?(user)
    current_user == user
  end
end
