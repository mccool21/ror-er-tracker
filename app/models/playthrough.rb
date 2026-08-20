class Playthrough < ApplicationRecord
  belongs_to :user
  has_many :found_items, dependent: :destroy

  validates :name, presence: true

  def found?(item)
    found_items.exists?(item_type: item.class.name, item_id: item.id)
  end

  def progress_for(item_class)
    { found: found_items.where(item_type: item_class.name).count, total: item_class.count }
  end
end
