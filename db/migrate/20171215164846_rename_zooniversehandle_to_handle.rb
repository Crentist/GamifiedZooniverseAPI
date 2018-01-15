class RenameZooniversehandleToHandle < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :handle, :handle
  end
end
