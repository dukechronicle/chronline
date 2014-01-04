class Topic::Response < ActiveRecord::Base

	@@blacklist = File.read("config/blacklist.txt").split(",").collect(&:strip).to_set

 # HAX: needed so that url_for works correctly for blog posts
  self.model_name.instance_variable_set(:@singular_route_key, "response")
  self.model_name.instance_variable_set(:@route_key, "responses")

	belongs_to :topic

	attr_accessible :content, :approved, :reported, :upvotes, :downvotes

	validates :content, presence: true, length: { maximum: 140 }

	before_create :blacklist

	# checks content for blacklisted words. If there is a blacklisted word,
	# the response is automatically reported.
	def blacklist
		content = self.content.split(",").collect(&:strip)
		content.each do |word|
			if @@blacklist.include?(word)
				self.reported = true
			end
		end
	end

end
