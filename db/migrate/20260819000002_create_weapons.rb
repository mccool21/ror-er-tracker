class CreateWeapons < ActiveRecord::Migration[8.1]
  def change
    create_table :weapons do |t|
      t.string :uid, null: false
      t.string :name
      t.string :image
      t.text :description
      t.text :location
      t.string :category
      t.float :weight
      t.json :attack
      t.json :defence
      t.json :scales_with
      t.json :required_attributes

      t.timestamps
    end
    add_index :weapons, :uid, unique: true
  end
end
