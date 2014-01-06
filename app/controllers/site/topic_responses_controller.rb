class Site::TopicResponsesController < Site::BaseController

	def create
		@response = Topic.find(params[:topic_id]).responses.build(params[:topic_response])
		if @response.save
			# some message?
		end
		redirect_to :back
	end

	def upvote
		@response = Topic::Response.find(params[:id])
		status = session_upvote_status(@response.id)
		if status == 1
			@response.update_attributes(upvotes: @response.upvotes + 1)
		elsif status == -1
			@response.update_attributes(upvotes: @response.upvotes - 1)
		end
		redirect_to :back
	end

	def downvote
		@response = Topic::Response.find(params[:id])
		status = session_downvote_status(@response.id)
		if status == 1
			@response.update_attributes(downvotes: @response.downvotes + 1)
		elsif status == -1
			@response.update_attributes(downvotes: @response.downvotes - 1)
		end
		redirect_to :back
	end

	def destroy
		@response = Topic::Response.find(params[:id])
		@response.destroy
		redirect_to :back
	end

	private

		def session_upvote_status(response_id)
			session_vote_helper(response_id, 0)
		end

		def session_downvote_status(response_id)
			session_vote_helper(response_id, 1)
		end

		def session_vote_helper(response_id, up_or_down)

			if session[:votes].nil?
				session[:votes] = { response_id => [false,false] }
			elsif !session[:votes].has_key?(response_id)
				session[:votes].merge! response_id => [false,false]
			end

			if up_or_down == 0
				this = 0
				other = 1
			elsif up_or_down == 1
				this = 1
				other = 0
			end

			votes = session[:votes][response_id]
			if votes[this] == false
				if votes[other] == false
					votes[this] = true
					return 1
				elsif votes[other] = true
					return 0
				end
			elsif votes[this] == true
				votes[this] = false
				return -1
			end

		end

end
