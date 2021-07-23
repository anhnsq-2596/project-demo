require "dotenv"

class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  
  paginates_per ENV["DEFAULT_RECORD_PER_PAGE"].to_i

  field :content, type: String
  belongs_to :user
  has_and_belongs_to_many :tags

  validates :content, presence: true, length: { maximum: 250 }

  def local_created_at
    created_at.localtime.strftime("%H:%M:%S - %d/%m/%Y")
  end
end
