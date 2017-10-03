class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :collaborations
  has_many :users, through: :collaborations
end
