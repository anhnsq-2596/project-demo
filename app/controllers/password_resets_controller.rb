class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user
      @user.send_password_reset_mail(params[:locale])
      flash[:success] = t("password_resets.mail.success")
      redirect_to login_url
    else
      flash.now[:danger] = t("password_resets.mail.invalid")
      render :new
    end
  end

  def edit
    unless @user&.validated?(params[:id])
      flash[:danger] = t("password_resets.invalid")
      redirect_to login_url
    end
  end

  def update
    if params[:user][:password].blank?
      @user&.errors.add(:password, "can't be empty")
      render :edit
    elsif @user&.update(user_params)
      flash[:success] = t("password_resets.success")
      @user.update_attribute(:reset_digest, nil)
      redirect_to login_url
    else
      render :edit
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end
end
