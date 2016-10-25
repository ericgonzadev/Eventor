class PagesController < ApplicationController
	def index
		visitor_latitude = request.location.latitude
		visitor_longitude = request.location.longitude
		@events = Event.featured(visitor_latitude, visitor_longitude)
	end

	def about
	end
end
