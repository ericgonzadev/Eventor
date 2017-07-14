class PagesController < ApplicationController
  def index
    # Test geocoding services locally by hardcoding latitude and longitude
    if Rails.env.development? || Rails.env.test?
      visitor_latitude = 34.05223 
      visitor_longitude = -118.24368
    else
      visitor_latitude = request.location.latitude
      visitor_longitude = request.location.longitude
    end

    @events = Event.featured(visitor_latitude, visitor_longitude)
  end

  def about
  end
end
