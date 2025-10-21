class DestinationsController < ApplicationController

  def index
    @destinations = Destination.order(featured: :desc, created_at: :desc).page(params[:page])
  end

  def show
    @destination = Destination.friendly.find(params[:id])
  end

  private
  # Write your private methods here
end
