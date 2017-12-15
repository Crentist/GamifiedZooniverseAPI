class AddAppIdToCollaboration < ActiveRecord::Migration[5.1]
  def change
    add_column :collaborations, :appId, :string
  end
end
