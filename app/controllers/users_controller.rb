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
      unless @user
        render_404
      end
    end

    def user_params
      params.require(:user).permit(
        :email,
        :name,
        :password,
        :password_confirmation
      )
    end

    def render_404
      respond_to do |format|
        format.html {
          render(file: "#{Rails.root}/public/404", 
            status: :not_found)
        }
        format.xml { head :not_found }
        format.any { head :not_found }
      end
    end
end
