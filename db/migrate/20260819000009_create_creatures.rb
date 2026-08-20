class CreateCreatures < ActiveRecord::Migration[8.1]
  def change
    create_table :creatures do |t|
      t.string :uid, null: false
      t.string :name
      t.string :image
      t.text :description
      t.text :location
      t.json :drops

      t.timestamps
    end
    add_index :creatures, :uid, unique: true
  end
end
