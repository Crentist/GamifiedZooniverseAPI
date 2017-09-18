class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :zooniverseHandle

      t.timestamps
    end
  end
end
