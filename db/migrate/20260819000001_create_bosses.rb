class CreateBosses < ActiveRecord::Migration[8.1]
  def change
    create_table :bosses do |t|
      t.string :uid, null: false
      t.string :name
      t.string :image
      t.text :description
      t.string :region
      t.text :location
      t.string :health_points
      t.json :drops

      t.timestamps
    end
    add_index :bosses, :uid, unique: true
  end
end
