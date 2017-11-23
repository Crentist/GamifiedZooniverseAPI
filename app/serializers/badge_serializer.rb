class BadgeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :criteria
  has_many :users
end
