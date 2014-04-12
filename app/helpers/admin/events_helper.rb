module Admin::EventsHelper

	def sorted_daily_events(events)
		events.sort_by!{|e| e.end_date}
	end
	
	def get_day(event)
		event.start_date.strftime('%d')
	end

	def get_time(event)
		event.start_date.strftime('%I:%M %p')
	end

	def day_url(key)
		clicked_on_day = key.strftime("%D")[3..4].to_i
		return day_admin_events_path(params[:year].to_i, 
									 params[:month].to_i, 
									 clicked_on_day)
	end

	def url_back_to_month
		return month_admin_events_path(params[:year].to_i,
									   params[:month].to_i)
	end

	def get_month_url(month)
		return month_admin_events_path(params[:year].to_i,
									   month)
	end

	def url_last_day
		if (params[:day].to_i > 1)
			return day_admin_events_path(params[:year].to_i,
									 	 params[:month].to_i,
										(params[:day].to_i - 1))
		else
			return last_month
		end
	end

	def url_next_day
		if (params[:day].to_i < 28)
			return day_admin_events_path(params[:year].to_i,
										 params[:month].to_i,
										(params[:day].to_i + 1))
		else
			return next_month
		end
	end

	def last_month
		if (params[:month].to_i > 1)
			return month_admin_events_path(params[:year].to_i,
										  (params[:month].to_i - 1))
		else
			return month_admin_events_path((params[:year].to_i - 1), 12)
		end
	end

	def next_month
		if (params[:month].to_i < 12)
			return month_admin_events_path(params[:year].to_i,
										  (params[:month].to_i + 1))
		else
			return month_admin_events_path((params[:year].to_i + 1), 01)
		end
	end
end