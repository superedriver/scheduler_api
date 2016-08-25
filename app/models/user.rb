class User < ApplicationRecord
  has_secure_password
  EMAIL_REGEXP = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  has_many :events, dependent: :destroy

  validates :email, presence: true,
                  uniqueness: { case_sensitive: false },
                  format: { with: EMAIL_REGEXP }
  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  before_save { self.email = email.downcase }
  before_create :create_token

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
    def create_token
      self.token = User.encrypt(User.new_token)
    end
end
