class StaticPagesController < ApplicationController
  def home
    @posts = Post.all.page(params[:page])
  end

  def about
  end
end
