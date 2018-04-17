class ChangeCollaborationDefaultValues < ActiveRecord::Migration[5.1]
  def change
    change_column :collaborations, :points, :integer, default: 0
    change_column :collaborations, :classification_count, :integer, default: 0
  end
end
