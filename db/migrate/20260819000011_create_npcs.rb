class CreateNpcs < ActiveRecord::Migration[8.1]
  def change
    create_table :npcs do |t|
      t.string :uid, null: false
      t.string :name
      t.string :image
      t.text :location
      t.text :quote
      t.string :role

      t.timestamps
    end
    add_index :npcs, :uid, unique: true
  end
end
