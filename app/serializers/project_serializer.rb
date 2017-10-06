class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name
  #attribute :users do
    #object.users.zooniverseHandle
    #tt = object.collaborations.each.select { | c | c.user.id; c.user.zooniverseHandle; c.points }
   # byebug
  #end

  has_many :collaborations
  has_many :users, through: :collaborations do
    #byebug
    h= object.collaborations.collect { | c | [[:id,c.user.id],[:zooniverseHandle,c.user.zooniverseHandle],[:points,c.points]]}
    h.map { |ar| ar.to_h }
  end
end

#def users
 # byebug
#  object.collaborations.users.map { |c| c.id; c.zooniverseHandle; c.points }
#end
