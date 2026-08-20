class CreateArmors < ActiveRecord::Migration[8.1]
  def change
    create_table :armors do |t|
      t.string :uid, null: false
      t.string :name
      t.string :image
      t.text :description
      t.text :location
      t.string :category
      t.float :weight
      t.json :dmg_negation
      t.json :resistance

      t.timestamps
    end
    add_index :armors, :uid, unique: true
  end
end
