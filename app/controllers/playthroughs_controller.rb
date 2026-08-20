class PlaythroughsController < ApplicationController
  before_action :set_playthrough, only: %i[ show destroy ]

  def index
    @playthroughs = Current.user.playthroughs.order(created_at: :desc)
  end

  def new
    @playthrough = Current.user.playthroughs.new
  end

  def create
    @playthrough = Current.user.playthroughs.new(playthrough_params)
    if @playthrough.save
      redirect_to @playthrough, notice: "Playthrough created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @progress = FoundItem::TRACKABLE_TYPES.map { |slug, klass| [ slug, klass, @playthrough.progress_for(klass) ] }
  end

  def destroy
    @playthrough.destroy
    redirect_to playthroughs_path, notice: "Playthrough deleted."
  end

  private
    def set_playthrough
      @playthrough = Current.user.playthroughs.find(params[:id])
    end

    def playthrough_params
      params.expect(playthrough: [ :name ])
    end
end
