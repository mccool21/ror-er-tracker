class Talisman < ApplicationRecord
  self.table_name = "talismans"
  include Findable
end
