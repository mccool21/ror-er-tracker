class ItemsController < ApplicationController
  before_action :set_playthrough
  before_action :set_item_class

  def index
    @items = @item_class.order(:name)
    @found_items_by_item_id = @playthrough.found_items.where(item_type: @item_class.name).index_by(&:item_id)
  end

  def show
    @item = @item_class.find(params[:item_id])
    @found_item = @playthrough.found_items.find_by(item_type: @item_class.name, item_id: @item.id)
  end

  private
    def set_playthrough
      @playthrough = Current.user.playthroughs.find(params[:id])
    end

    def set_item_class
      @item_type = params[:item_type]
      @item_class = FoundItem::TRACKABLE_TYPES.fetch(@item_type) { raise ActiveRecord::RecordNotFound }
    end
end
