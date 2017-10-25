class AddClassificationCountToCollaboration < ActiveRecord::Migration[5.1]
  def change
    add_column :collaborations, :classification_count, :integer
  end
end
