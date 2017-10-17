class AddReferencesToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :projects, foreign_key: true
    add_reference :users, :owned_projects, foreign_key: true
  end
end
