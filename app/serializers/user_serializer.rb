class UserSerializer < ActiveModel::Serializer
  attributes :id, :handle

  has_many :owned_projects
  has_many :collaborations
end
