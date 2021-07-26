class StaticPagesController < ApplicationController
  def home
    if params[:filter].present?
      tag_ids = Tag.where(label: params[:filter]).pluck(:id)
      @posts = Post.where(:tag_ids.in => tag_ids).page(params[:page])
    else
      @posts = Post.search(params[:search]).desc_order_by_created_at.page(
        params[:page])
    end
    @tags = Tag.all
  end

  def about
  end
end
