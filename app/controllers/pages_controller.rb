class PagesController < ApplicationController
  # Fallback coordinates (Los Angeles) for when IP geolocation fails
  # or is unavailable (dev/test, connection refused, nil location, etc.)
  DEFAULT_LATITUDE = 34.05223
  DEFAULT_LONGITUDE = -118.24368

  def index
    if Rails.env.development? || Rails.env.test?
      visitor_latitude = DEFAULT_LATITUDE
      visitor_longitude = DEFAULT_LONGITUDE
    else
      location = request.location
      visitor_latitude  = location&.latitude  || DEFAULT_LATITUDE
      visitor_longitude = location&.longitude || DEFAULT_LONGITUDE
    end

    @events = Event.featured(visitor_latitude, visitor_longitude)
  end

  def about
  end
end
