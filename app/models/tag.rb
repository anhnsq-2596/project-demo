class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :label, type: String
  index({ label: 1 }, { unique: true })
  
  validates :label, presence: true, length: { minimum: 3, maximum: 30 }, 
   uniqueness: true
end
