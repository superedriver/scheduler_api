class Event < ApplicationRecord
  belongs_to :user
  validates :user_id, :date_start, :date_finish, presence: true
end
