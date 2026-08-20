module Findable
  extend ActiveSupport::Concern

  included do
    has_many :found_items, as: :item, dependent: :destroy
  end
end
