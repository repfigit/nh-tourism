class ActivitiesController < ApplicationController

  def index
    @activities = Activity.order(created_at: :desc).page(params[:page])
  end

  private
  # Write your private methods here
end
