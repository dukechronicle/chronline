class Api::EventsController < Api::BaseController
	def daily
		events = Event.day(params[:year],
						   params[:month],
						   params[:day])
		respond_with events
	end
end