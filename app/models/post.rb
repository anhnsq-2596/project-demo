class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  belongs_to :user
  has_and_belongs_to_many :tags

  validates :content, presence: true, length: { maximum: 250 }
end
