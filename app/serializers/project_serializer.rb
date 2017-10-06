class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :collaborations
  has_many :users, through: :collaborations do
    h= object.collaborations.collect { | c | [[:id,c.user.id],[:zooniverseHandle,c.user.zooniverseHandle],[:points,c.points]]}
    h.map { |ar| ar.to_h }
  end
end
