class RemoveCollaboratorsFromProject < ActiveRecord::Migration[5.1]
  def change
    remove_reference :projects, :collaborators, index:true, foreign_key: true
  end
end
