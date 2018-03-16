class AddSiteToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :site, :string
  end
end
