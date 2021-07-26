require "dotenv"

class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  
  paginates_per ENV["DEFAULT_RECORD_PER_PAGE"].to_i

  field :title, type: String
  field :content, type: String
  belongs_to :user
  has_and_belongs_to_many :tags

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 250 }
  index({ title: "text", content: "text" })

  def local_created_at
    created_at.localtime.strftime("%H:%M:%S - %d/%m/%Y")
  end

  def description
    words = content.split
    words.size > 10 ? words[...10].join(" ") << "..." : content
  end

  scope :desc_order_by_created_at, -> { order_by(created_at: :desc) }
  scope :search, -> (value) { where("$text" => { 
    "$search" => value }) if value.present? }
end
