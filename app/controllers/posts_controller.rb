class PostsController < ApplicationController
  include SessionsHelper
  include PostsHelper
  before_action :validate_login, only: [:new, :edit, :create, :update, :destroy]
  before_action :get_current_user, only: [:new, :edit, :create, :update]
  before_action :get_post, only: [:edit, :update, :show, :destroy]
  before_action :validate_user, only: [:edit, :update, :destroy]
  
  def show
  end

  def new
    @post = Post.new
    @tags = tags_for(nil)
  end

  def create
    @post = @user.posts.build(post_params)
    @post.tags = get_tags(params[:tags]) if tags_available?
    
    if @post.save
      redirect_to root_url
    else
      @tags = tags_for(nil)
      render :new
    end
  end
  
  def edit
    @tags = tags_for(@post)
  end

  def update
    if @post.update(post_params)
      @post.tags << get_tags(params[:tags]) if tags_available?
      @post.update_attribute(:tag_ids, @post.tag_ids)
      
      flash[:success] = t("posts.update.success")
      redirect_to post_path(@post)
    else
      @tags = tags_for(@post)
      render :edit
    end
  end

  def destroy
    if @post.destroy
      flash[:success] = t("posts.delete.success")
      redirect_to root_url
    else
      flash[:danger] = t("posts.delete.fail")
      redirect_to root_url
    end
  end

  def validate_user
    unless authorized_with?(@post.user)
      flash[:danger] = t("commons.unauthorized")
      redirect_to root_url
    end
  end

  private
    def post_params
      params.require(:post).permit(:title, :content)
    end

    def get_current_user
      @user = current_user
    end

    def get_post
      @post = Post.find(params[:id])
      unless @post
        flash[:danger] = t("posts.not_found")
        redirect_to root_url
      end
    end
end
