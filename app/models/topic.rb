class Topic < ActiveRecord::Base
  
	has_many :responses
	
	attr_accessible :title, :description

	validates :title, presence: true
	validates :description, presence: true, length: { maximum: 100 }

end
