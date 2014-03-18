class Site::EventsController < Site::BaseController
	def new
		@new_event = Event.new
	end

	def create
		@new_event = Event.new(params[:event])
		if @new_event.save
			flash[:success] = "Event created"
			year = @new_event.start_date.year
			month = @new_event.start_date.month
			redirect_to month_admin_events_path(year, month)
		else
			flash[:error] = "Incorrect Input"
			redirect_to :back
		end
	end

	def monthly
		@today = get_today

		@year = params[:year].to_i
		@month = params[:month].to_i
		@day = Date.today.strftime('%d').to_i

		@daily_events = get_daily_events(@year, @month, @day)
		@day_str = Date.today.strftime('%A %B %d, %Y')

		@keys = make_keys(@year, @month)
		@map = get_map(@year, @month, @keys)
		@front_offset = get_front_offset
		@end_offset = get_end_offset(@front_offset)
		@month_name = get_month_name
	end

	def change_day
		day = params['day'].to_i
		month = params[:month].to_i
		year = params[:year].to_i
		date = Date.new(year, month, day)
		@daily_events = get_daily_events(year, month, day)
		@day_str = date.strftime('%A %B %d, %Y')
	end

	def daily
		year = params[:year].to_i
		month = params[:month].to_i
		day = params[:day].to_i
		date = Date.new(year, month, day)
		@daily_events = get_daily_events(year, month, day)
		@day_str = date.strftime('%A %B %d, %Y')
	end

	private

	def get_month_name
		Date.new(params[:year].to_i, 
				 params[:month].to_i, 
				 1).strftime('%B')
	end

	def get_front_offset
		date = Date.new(params[:year].to_i, 
						params[:month].to_i, 
						1)
		#If the first day of month is Tues, return 2
		return date.strftime('%w').to_i
	end

	def get_end_offset(front)
		num_days = Time.days_in_month(params[:month].to_i, 
								      params[:year].to_i)
		if ((get_front_offset + num_days) > 35) 
		 	return (42 - num_days - front)
		else
		 	return (35 - num_days - front) 
		end
	end


	def get_map(year, month, keys)
		map = Hash.new
		keys.each {|key| map[key] = get_daily_events(year, month, key.day) }
		return map
	end

	def make_keys(year, month)
		num_days = Time.days_in_month(month, year)
		start_of_month = Date.new(year, month, 1)
		end_of_month = Date.new(year, month, num_days)
		return start_of_month.to_date..end_of_month
	end

	def to_time(event)
		event.start_date.strftime('%D')
	end

	def get_today
		return Time.now.strftime('%D')
	end

	def get_daily_events(year, month, day)
		Event.where('EXTRACT(DAY from start_date AT TIME ZONE ?) = ? AND
									 EXTRACT(MONTH from start_date) = ? AND
		 						     EXTRACT(YEAR from start_date) = ?', 'IOT',
		 						     day, month, year).sort_by!{|e| e.start_date}
	end

end