class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :date_start, :date_finish, :associate
end
