class User
  EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  include Mongoid::Document
  include ActiveModel::SecurePassword
  
  field :email, type: String
  field :name, type: String
  field :password_digest, type: String

  has_secure_password

  before_save :downcase_email

  validates :email, presence: true,
    uniqueness: true,
    format: { with: EMAIL_FORMAT }

  validates :name, presence: true
  validates :password, presence: true,
    length: { minimum: 6 },
    allow_nil: true

  private
    def downcase_email
      email.downcase!
    end
    
end
