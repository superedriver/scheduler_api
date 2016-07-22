class EventSerializer < ActiveModel::Serializer
  attributes :name, :description, :date_start, :date_finish, :assosiate

  belongs_to :user
end
