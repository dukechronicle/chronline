class Response < ActiveRecord::Base

		belongs_to :topic

		attr_accessible :content

		validates :content, presence: true, length: { maximum: 140 }

end
