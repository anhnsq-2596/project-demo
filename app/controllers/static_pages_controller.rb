class StaticPagesController < ApplicationController
  def home
    @posts = Post.order_by(created_at: :desc).all.page(params[:page])
  end

  def about
  end
end
