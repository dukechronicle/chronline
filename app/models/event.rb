class Event < ActiveRecord::Base
  attr_accessible :content, :end_date, :start_date, :title
  validate [:title, :content, :start_date, :end_date], :presence => true
end
