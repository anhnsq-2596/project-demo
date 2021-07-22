class TagsController < ApplicationController
  include SessionsHelper
  before_action :validate_login, only: [:new, :edit, :create, :update, :destroy]
  def new 
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      flash[:success] = t("tags.create.success")
      redirect_to new_tag_url
    else
      render :new
    end
  end

  private
    def tag_params
      params.require(:tag).permit(:label)    
    end
end
