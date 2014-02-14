module TopicsHelper

	def hasupvoted(topic_response)
		session[:upvotes][topic_response.id]
	end

	def hasdownvoted(topic_response)
		session[:downvotes][topic_response.id]
	end

end