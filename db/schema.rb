# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_20_142959) do
  create_table "armors", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.json "dmg_negation"
    t.string "image"
    t.text "location"
    t.string "name"
    t.json "resistance"
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.float "weight"
    t.index ["uid"], name: "index_armors_on_uid", unique: true
  end

  create_table "ashes_of_war", force: :cascade do |t|
    t.string "affinity"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "image"
    t.text "location"
    t.string "name"
    t.string "skill"
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_ashes_of_war_on_uid", unique: true
  end

  create_table "bosses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.json "drops"
    t.string "health_points"
    t.string "image"
    t.text "location"
    t.string "name"
    t.string "region"
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_bosses_on_uid", unique: true
  end

  create_table "creatures", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.json "drops"
    t.string "image"
    t.text "location"
    t.string "name"
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_creatures_on_uid", unique: true
  end

  create_table "found_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "found_at"
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.integer "playthrough_id", null: false
    t.datetime "updated_at", null: false
    t.index ["item_type", "item_id"], name: "index_found_items_on_item_type_and_item_id"
    t.index ["playthrough_id", "item_type", "item_id"], name: "index_found_items_on_playthrough_and_item", unique: true
    t.index ["playthrough_id"], name: "index_found_items_on_playthrough_id"
  end

  create_table "incantations", force: :cascade do |t|
    t.integer "cost"
    t.datetime "created_at", null: false
    t.text "description"
    t.text "effects"
    t.string "image"
    t.text "location"
    t.string "name"
    t.json "requirements"
    t.integer "slots"
    t.string "spell_type"
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_incantations_on_uid", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "image"
    t.string "name"
    t.string "region"
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_locations_on_uid", unique: true
  end

  create_table "npcs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "image"
    t.text "location"
    t.string "name"
    t.text "quote"
    t.string "role"
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_npcs_on_uid", unique: true
  end

  create_table "playthroughs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_playthroughs_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "shields", force: :cascade do |t|
    t.json "attack"
    t.string "category"
    t.datetime "created_at", null: false
    t.json "defence"
    t.text "description"
    t.string "image"
    t.text "location"
    t.string "name"
    t.json "required_attributes"
    t.json "scales_with"
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.float "weight"
    t.index ["uid"], name: "index_shields_on_uid", unique: true
  end

  create_table "sorceries", force: :cascade do |t|
    t.integer "cost"
    t.datetime "created_at", null: false
    t.text "description"
    t.text "effects"
    t.string "image"
    t.text "location"
    t.string "name"
    t.json "requirements"
    t.integer "slots"
    t.string "spell_type"
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_sorceries_on_uid", unique: true
  end

  create_table "talismans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.text "effect"
    t.string "image"
    t.text "location"
    t.string "name"
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_talismans_on_uid", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name"
    t.string "password_digest"
    t.string "provider"
    t.integer "role", default: 0, null: false
    t.string "uid"
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  create_table "weapons", force: :cascade do |t|
    t.json "attack"
    t.string "category"
    t.datetime "created_at", null: false
    t.json "defence"
    t.text "description"
    t.string "image"
    t.text "location"
    t.string "name"
    t.json "required_attributes"
    t.json "scales_with"
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.float "weight"
    t.index ["uid"], name: "index_weapons_on_uid", unique: true
  end

  add_foreign_key "found_items", "playthroughs"
  add_foreign_key "playthroughs", "users"
  add_foreign_key "sessions", "users"
end
