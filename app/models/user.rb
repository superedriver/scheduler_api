class User < ApplicationRecord
  has_secure_password
  EMAIL_REGEXP = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  has_many :events, dependent: :destroy

  validates :email, presence: true,
                  uniqueness: { case_sensitive: false },
                  format: { with: EMAIL_REGEXP }

  # validates :password, length: { minimum: 3 }, if: -> { new_record? || changes["password"] }
  # validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
  # validates :password_confirmation, presence: true, if: -> { new_record? || changes["password"] }

  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
end
