class UserSerializer < ActiveModel::Serializer
  attributes :id, :zooniverseHandle

  has_many :collaborations
end
