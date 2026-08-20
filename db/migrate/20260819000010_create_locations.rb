class CreateLocations < ActiveRecord::Migration[8.1]
  def change
    create_table :locations do |t|
      t.string :uid, null: false
      t.string :name
      t.string :image
      t.text :description
      t.string :region

      t.timestamps
    end
    add_index :locations, :uid, unique: true
  end
end
