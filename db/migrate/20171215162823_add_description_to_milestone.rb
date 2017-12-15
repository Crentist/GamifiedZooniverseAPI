class AddDescriptionToMilestone < ActiveRecord::Migration[5.1]
  def change
    add_column :milestones, :description, :string
  end
end
