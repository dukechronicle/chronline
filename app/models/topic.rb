class Topic < ActiveRecord::Base
  
	has_many :responses, class_name: 'Topic::Response', dependent: :destroy
	
	attr_accessible :title, :description

	validates :title, presence: true
	validates :description, presence: true, length: { maximum: 100 }

end
