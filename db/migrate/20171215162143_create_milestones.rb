class CreateMilestones < ActiveRecord::Migration[5.1]
  def change
    create_table :milestones do |t|
      t.string :subject
      t.integer :value

      t.timestamps
    end
  end
end
