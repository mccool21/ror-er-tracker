class FoundItem < ApplicationRecord
  belongs_to :playthrough
  belongs_to :item, polymorphic: true

  TRACKABLE_TYPES = {
    "weapons" => Weapon,
    "armors" => Armor,
    "shields" => Shield,
    "talismans" => Talisman,
    "incantations" => Incantation,
    "sorceries" => Sorcery,
    "ashes_of_war" => AshOfWar,
    "bosses" => Boss,
    "creatures" => Creature,
    "npcs" => Npc,
    "locations" => Location
  }.freeze

  validates :item_type, inclusion: { in: TRACKABLE_TYPES.values.map(&:name) }
  validates :playthrough_id, uniqueness: { scope: %i[item_type item_id] }
end
