class AddTimestampsToCollaboration < ActiveRecord::Migration[5.1]
  def change
    add_timestamps :collaborations, null: true
  end
end
