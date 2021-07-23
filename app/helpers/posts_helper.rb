module PostsHelper
  def tags_available?
    params[:tags] && !params[:tags].first.empty? && !params[:tags].empty?
  end

  def tags_for(post)
    if post && !post.tags.empty?
      Tag.where(:id.nin => @post.tag_ids)
    else
      Tag.all
    end
  end

  def get_tags(tag_ids)
    tag_ids.map { |id| Tag.find(id) }
  end
end
