class PagesController < ApplicationController
	def index
		visitor_latitude = request.safe_location.latitude
		visitor_longitude = request.safe_location.longitude
		@events = Event.featured(visitor_latitude, visitor_longitude)
	end

	def about
	end
end
