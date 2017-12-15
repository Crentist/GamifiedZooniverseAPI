class RenameZooniversehandleToHandle < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :zooniverseHandle, :handle
  end
end
