class HomeController < ApplicationController
  include HomeDemoConcern

  def index
    @featured_destinations = Destination.where(featured: true).limit(6)
    @attractions = Attraction.limit(4)
    @activities = Activity.limit(6)
  end
end
