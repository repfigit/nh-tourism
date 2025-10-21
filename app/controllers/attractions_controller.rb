class AttractionsController < ApplicationController

  def index
    @attractions = Attraction.order(created_at: :desc).page(params[:page])
  end

  private
  # Write your private methods here
end
