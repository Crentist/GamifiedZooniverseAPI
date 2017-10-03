class CreateCollaboration < ActiveRecord::Migration[5.1]
  def change
    create_table :collaborations do |t|
      t.integer :points
      t.belongs_to :project, index: true
      t.belongs_to :user, index: true
    end
  end
end
