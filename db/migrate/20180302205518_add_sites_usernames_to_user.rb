class AddSitesUsernamesToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sitesUsernames, :string, default: ""
  end
end
