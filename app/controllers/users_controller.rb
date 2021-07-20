class UsersController < ApplicationController
  before_action :get_user, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_url
    else
      render :new
    end
  end

  private
    def get_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :email,
        :name,
        :password,
        :password_confirmation
      )
    end
end
