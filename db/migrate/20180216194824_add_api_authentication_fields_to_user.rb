class AddApiAuthenticationFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :auth_token, :string
    add_column :users, :auth_token_expires_at, :datetime
    add_column :users, :encrypted_password, :string, null: false, default: ""
    add_column :users, :sign_in_count, :integer, default: 0, null: false
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
  end
end
