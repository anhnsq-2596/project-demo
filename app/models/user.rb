class User
  EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  include Mongoid::Document
  field :email, type: String
  field :name, type: String

  before_save :downcase_email

  validates :email, presence: true,
    uniqueness: true,
    format: { with: EMAIL_FORMAT }

  validates :name, presence: true

  private
    def downcase_email
      email.downcase!
    end
    
end
