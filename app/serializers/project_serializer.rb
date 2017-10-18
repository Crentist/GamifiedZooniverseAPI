class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name

  belongs_to :owner
  has_many :collaborations
  has_many :collaborators, through: :collaborations do
    h= object.collaborations.collect { | c | [[:id,c.collaborator.id],[:zooniverseHandle,c.collaborator.zooniverseHandle],[:points,c.points]]}
    h.map { |ar| ar.to_h }
  end
end
