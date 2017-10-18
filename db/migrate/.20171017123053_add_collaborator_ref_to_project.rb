class AddCollaboratorRefToProject < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :collaborators, foreign_key: true
  end
end
