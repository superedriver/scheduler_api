class User < ApplicationRecord
  EMAIL_REGEXP = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  has_many :events, dependent: :destroy

  validates :email, presence: true,
                  uniqueness: { case_sensitive: false },
                  format: { with: EMAIL_REGEXP }
end
