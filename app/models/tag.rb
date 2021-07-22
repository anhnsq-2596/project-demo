class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :label, type: String
  has_and_belongs_to_many :posts
  index({ label: 1 }, { unique: true })
  
  validates :label, presence: true, length: { minimum: 3, maximum: 30 }, 
   uniqueness: true
end
