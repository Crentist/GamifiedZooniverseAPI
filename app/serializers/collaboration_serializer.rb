class CollaborationSerializer < ActiveModel::Serializer
  attributes :id, :points, :created_at, :updated_at, :classification_count

  def created_at
    object.created_at.to_date.strftime("%d-%m-%Y")
  end

  def updated_at
    object.updated_at.to_date.strftime("%d-%m-%Y")
  end
end
