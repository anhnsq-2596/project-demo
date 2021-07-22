class User
  EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  include Mongoid::Document
  include ActiveModel::SecurePassword
  
  field :email, type: String
  field :name, type: String
  field :password_digest, type: String
  field :reset_digest, type: String

  attr_accessor :reset_token

  has_many :posts

  has_secure_password

  before_save :downcase_email

  validates :email, presence: true, uniqueness: true,
   format: { with: EMAIL_FORMAT }

  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def authenticated?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def validated?(token)
    return false if reset_digest.nil?
    BCrypt::Password.new(reset_digest).is_password?(token)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
  end

  def send_password_reset_mail(locale)
    create_reset_digest
    UserMailer.password_reset(self, locale).deliver_now
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(string)
    cost = 2
    BCrypt::Password.create(string, cost: cost)
  end

  private
    def downcase_email
      email.downcase!
    end
end
