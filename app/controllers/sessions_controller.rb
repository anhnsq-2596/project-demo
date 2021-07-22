class SessionsController < ApplicationController
  include SessionsHelper
  
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticated?(params[:session][:password])
      session[:user_id] = @user.id
      redirect_to root_url
    else
      flash.now[:danger] = t("sessions.login.error")
      render :new
    end
  end

  def destroy
    log_out
    redirect_to login_url
  end
end
