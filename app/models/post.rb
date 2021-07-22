require 'dotenv'

class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  
  paginates_per ENV['DEFAULT_RECORD_PER_PAGE'].to_i

  field :content, type: String
  belongs_to :user
  has_and_belongs_to_many :tags

  validates :content, presence: true, length: { maximum: 250 }

  def get_tags(tag_ids_arr)
    valid_ids = tag_ids_arr.map { |id| BSON::ObjectId(id) }
    (tag_ids << valid_ids).flatten!
  end
end
