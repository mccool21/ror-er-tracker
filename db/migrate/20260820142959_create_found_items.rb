class CreateFoundItems < ActiveRecord::Migration[8.1]
  def change
    create_table :found_items do |t|
      t.references :playthrough, null: false, foreign_key: true
      t.string :item_type, null: false
      t.integer :item_id, null: false
      t.datetime :found_at

      t.timestamps
    end

    add_index :found_items, [ :item_type, :item_id ]
    add_index :found_items, [ :playthrough_id, :item_type, :item_id ], unique: true, name: "index_found_items_on_playthrough_and_item"
  end
end
