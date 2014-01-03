class Topic::Response < ActiveRecord::Base

 # HAX: needed so that url_for works correctly for blog posts
  self.model_name.instance_variable_set(:@singular_route_key, "response")
  self.model_name.instance_variable_set(:@route_key, "responses")

	belongs_to :topic

	attr_accessible :content

	validates :content, presence: true, length: { maximum: 140 }

	before_save :set_votes

	def set_votes
		self.upvotes = 0
		self.downvotes = 0
	end
		
end
