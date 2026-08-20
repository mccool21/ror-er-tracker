class FoundItemsController < ApplicationController
  before_action :set_playthrough

  def create
    item_class = FoundItem::TRACKABLE_TYPES.fetch(params[:item_type]) { raise ActiveRecord::RecordNotFound }
    item = item_class.find(params[:item_id])

    @playthrough.found_items.find_or_create_by(item_type: item_class.name, item_id: item.id) do |found_item|
      found_item.found_at = Time.current
    end

    redirect_back fallback_location: playthrough_path(@playthrough), notice: "Marked as found."
  end

  def destroy
    @playthrough.found_items.find(params[:id]).destroy
    redirect_back fallback_location: playthrough_path(@playthrough), notice: "Marked as not found."
  end

  private
    def set_playthrough
      @playthrough = Current.user.playthroughs.find(params[:playthrough_id])
    end
end
