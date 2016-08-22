class Event < ApplicationRecord
  belongs_to :user
  validates :user_id, :date_start, :date_finish, presence: true
  validate :finish_is_greater_than_start

  private

  def finish_is_greater_than_start
    errors.add(:date_finish, I18n.t("activerecord.errors.models.event.attributes.date_finish.not_greater")) if date_start_is_grate?
  end

  def  date_start_is_grate?
    date_start.present? && date_finish.present? && date_start >= date_finish
  end
end
