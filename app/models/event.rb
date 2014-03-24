class Event < ActiveRecord::Base
  attr_accessible :content, :end_date, :start_date, :title, :filter
  validate [:title, :content, :filter, :start_date, :end_date], :presence => true
end
