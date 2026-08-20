# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Elden Ring reference data, extracted from elden-ring-companion.html (originally sourced from
# https://eldenring.fanapis.com). Each dataset lives in db/seed_data/*.json and is upserted here
# by its stable `uid` so re-running db:seed is safe.

SEED_DATA_PATH = Rails.root.join("db", "seed_data")

def load_seed_data(filename)
  JSON.parse(File.read(SEED_DATA_PATH.join(filename)))
end

def seed_model!(model:, filename:, attributes:)
  records = load_seed_data(filename)
  records.each do |record|
    model.find_or_create_by!(uid: record["uid"]) do |row|
      attributes.each { |attr| row[attr] = record[attr] }
    end
  end
  puts "Seeded #{records.size} #{model.name.underscore.pluralize}"
end

seed_model!(
  model: Boss,
  filename: "bosses.json",
  attributes: %w[name image description region location health_points drops]
)

seed_model!(
  model: Weapon,
  filename: "weapons.json",
  attributes: %w[name image description location category weight attack defence scales_with required_attributes]
)

seed_model!(
  model: Armor,
  filename: "armors.json",
  attributes: %w[name image description location category weight dmg_negation resistance]
)

seed_model!(
  model: Shield,
  filename: "shields.json",
  attributes: %w[name image description location category weight attack defence scales_with required_attributes]
)

seed_model!(
  model: Talisman,
  filename: "talismans.json",
  attributes: %w[name image description location effect]
)

seed_model!(
  model: Sorcery,
  filename: "sorceries.json",
  attributes: %w[name image description location spell_type cost slots effects requirements]
)

seed_model!(
  model: Incantation,
  filename: "incantations.json",
  attributes: %w[name image description location spell_type cost slots effects requirements]
)

seed_model!(
  model: AshOfWar,
  filename: "ashes_of_war.json",
  attributes: %w[name image description location affinity skill]
)

seed_model!(
  model: Creature,
  filename: "creatures.json",
  attributes: %w[name image description location drops]
)

seed_model!(
  model: Location,
  filename: "locations.json",
  attributes: %w[name image description region]
)

seed_model!(
  model: Npc,
  filename: "npcs.json",
  attributes: %w[name image location quote role]
)

admin_email = ENV.fetch("ADMIN_EMAIL", "admin@example.com").strip.downcase

admin = User.find_or_initialize_by(email_address: admin_email)
if admin.new_record?
  admin.password = SecureRandom.hex(16)
  admin.name ||= "Admin"
end
admin.role = :admin
admin.save!(validate: admin.new_record?)

puts "Admin user ready: #{admin.email_address} (role: #{admin.role})"
