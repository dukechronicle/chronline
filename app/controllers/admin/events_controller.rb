class Admin::EventsController < Admin::BaseController
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

	def index
		@map = get_map(Event.all)
		@keys = make_keys(2)
	end

	def monthly
		@today = get_today
		@map = get_map(Event.all)
		@keys = make_keys(params[:month].to_i)
		@front_offset = get_front_offset
		@end_offset = get_end_offset(@front_offset)
		@month_name = get_month_name
	end

	def daily
		day = Date.new(params[:year].to_i, 
					   params[:month].to_i, 
					   params[:day].to_i)
		@all = Event.all
		@daily_events = []
		@all.each {|event| 
			if (event.start_date.to_date == day)
				@daily_events.push(event)
			end
		}
		@daily_events.sort_by!{|e| e.start_date}
		@day_str = day.strftime('%A %B %d, %Y')

	end

	private

	def get_month_name
		return Date.new(params[:year].to_i, 
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
		num_days = get_num_days(params[:month].to_i)
		return (35 - num_days - front)
	end


	def get_map(events)
		map = Hash.new
		events.each do |event|
			if !map[to_time(event)]
				map[to_time(event)] = []
			end
			map[to_time(event)].push(event)
		end
		return map
	end

	def get_num_days(month)
		if(month == 2) #Feb
			return 28
		elsif (month== 8) #Aug
			return 31
		elsif (month < 8 && (month % 2) == 0) #Apr #Jun
			return 30
		elsif (month < 8 && (month % 2) != 0) #Jan #Mar #May #July
			return 31
		elsif (month > 8 && (month % 2) == 0) #Oct #Dec
			return 31
		else #Sep #Nov
			return 30
		end
	end

	def make_keys(month)
		num_days = get_num_days(month)
		start_of_month = Date.new(2014, month, 1)
		end_of_month = Date.new(2014, month, num_days)
		return (start_of_month.to_date..end_of_month).map{ 
			|date| date.strftime("%D") }
	end

	def to_time(event)
		timezone = 'Eastern Time (US & Canada)'
		event.start_date.strftime('%D')
	end

	def get_today
		timezone = 'Eastern Time (US & Canada)'
		return Time.now.strftime('%D')
	end

end