class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :users

  has_many :collaborations
  has_many :users, through: :collaborations
end

#def users
#  byebug
#  object.collaborations.users.map { |c| c.id; c.zooniverseHandle; c.points }
#end
