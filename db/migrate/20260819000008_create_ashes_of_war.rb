class CreateAshesOfWar < ActiveRecord::Migration[8.1]
  def change
    create_table :ashes_of_war do |t|
      t.string :uid, null: false
      t.string :name
      t.string :image
      t.text :description
      t.text :location
      t.string :affinity
      t.string :skill

      t.timestamps
    end
    add_index :ashes_of_war, :uid, unique: true
  end
end
