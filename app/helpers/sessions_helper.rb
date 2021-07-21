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
end
