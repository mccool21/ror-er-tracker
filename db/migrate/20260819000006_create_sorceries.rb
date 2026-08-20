class CreateSorceries < ActiveRecord::Migration[8.1]
  def change
    create_table :sorceries do |t|
      t.string :uid, null: false
      t.string :name
      t.string :image
      t.text :description
      t.text :location
      t.string :spell_type
      t.integer :cost
      t.integer :slots
      t.text :effects
      t.json :requirements

      t.timestamps
    end
    add_index :sorceries, :uid, unique: true
  end
end
