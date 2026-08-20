class CreateTalismans < ActiveRecord::Migration[8.1]
  def change
    create_table :talismans do |t|
      t.string :uid, null: false
      t.string :name
      t.string :image
      t.text :description
      t.text :location
      t.text :effect

      t.timestamps
    end
    add_index :talismans, :uid, unique: true
  end
end
