class BadgesController < ApplicationController
  before_action :set_badge, only: [:show, :update, :destroy]

  # GET /badges
  def index
    @badges = Badge.all

    json_response(@badges)
  end

  # GET /badges/1
  def show
    json_response(@badge)
  end

  # POST /badges
  def create
    @badge = Badge.new(badge_params)

    if @badge.save
      json_response(@badge, :created)
    else
      render json: @badge.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /badges/1
  def update
    if @badge.update(badge_params)
      json_response(@badge, :ok)
    else
      render json: @badge.errors, status: :unprocessable_entity
    end
  end

  # DELETE /badges/1
  def destroy
    @badge.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_badge
      @badge = Badge.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def badge_params
      params.fetch(:badge, {})
    end
end
