class Response < ActiveRecord::Base

		belongs_to :topic

		attr_accessible :content, :topic_id

		validates :content, presence: true, length: { maximum: 140 }

		before_save :set_votes

		def set_votes
			self.upvotes = 0
			self.downvotes = 0
		end
		
end
