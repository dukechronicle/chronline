class Event < ActiveRecord::Base
    attr_accessible :content, :end_date, :start_date, :title, :filter
    validate [:title, :content, :filter, :start_date, :end_date], :presence => true

    def self.day(year, month, day)
		self.where('EXTRACT(DAY from start_date AT TIME ZONE ?) = ? AND
					EXTRACT(MONTH from start_date) = ? AND
		 			EXTRACT(YEAR from start_date) = ?', 'IOT',
		 			day, month, year).sort_by!{|e| e.start_date}
	end

	 def self.month(year, month)
		self.where('EXTRACT(MONTH from start_date) = ? AND
		 			EXTRACT(YEAR from start_date) = ?', 'IOT',
		 			day, month, year).sort_by!{|e| e.start_date}
	end

	 def self.year(year)
		self.where('EXTRACT(YEAR from start_date) = ?', 'IOT',
		 			day, month, year).sort_by!{|e| e.start_date}
	end
end
