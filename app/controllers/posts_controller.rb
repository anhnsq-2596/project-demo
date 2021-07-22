class PostsController < ApplicationController
  include SessionsHelper
  before_action :validate_login, only: [:new, :edit, :create, :update, :destroy]
  before_action :get_current_user, only: [:new, :edit, :create, :update]
  before_action :validate_user, only: [:edit, :update, :destroy]
  
  def show
    @post = Post.find(BSON::ObjectId(params[:id]))
  end

  def new
    @post = Post.new
    @tags = Tag.all
  end

  def create
    @post = @user.posts.build(post_params)
    if params[:tags] && !params[:tags].empty?
      tag_ids = params[:tags].map { |id| BSON::ObjectId(id) }
      (@post.tag_ids << tag_ids).flatten!
    end
    if @post.save
      redirect_to root_url
    else
      @tags = Tag.all
      render :new
    end
  end
  
  def edit
  end

  private
    def post_params
      params.require(:post).permit(:content)
    end

    def get_current_user
      @user = current_user
    end

    def validate_login
      unless logged_in?
        flash[:danger] = t("commons.login_required")      
        redirect_to login_url
      end
    end
end
