class UserSerializer < ActiveModel::Serializer
  attributes :name, :email

  has_many :events
end
