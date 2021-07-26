class StaticPagesController < ApplicationController
  def home
    @posts = Post.search(params[:search]).desc_order_by_created_at.page(
      params[:page])
  end

  def about
  end
end
