class UserSerializer < ActiveModel::Serializer
  attributes :id, :zooniverseHandle

  has_many :owned_projects
  has_many :collaborations
end
