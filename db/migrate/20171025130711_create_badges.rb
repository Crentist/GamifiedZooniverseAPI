class CreateBadges < ActiveRecord::Migration[5.1]
  def change
    create_table :badges do |t|
      t.string :name
      t.string :image
      t.string :description

      t.timestamps
    end
  end
end
