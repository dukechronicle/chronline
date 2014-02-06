class Site::TopicResponsesController < Site::BaseController

	def create
		@response = Topic.find(params[:topic_id]).responses.build(params[:topic_response])
		respond_to do |format|
	    if verify_recaptcha and @response.save
				format.html { redirect_to :back }
			else
				# some error?
			end
		end
	end

	def upvote
		@response = Topic::Response.find(params[:id])
		respond_to do |format|
			status = session_upvote_status(@response.id)
			votes = @response.upvotes
			if status == :has_not_voted
				votes = votes + 1
			elsif status == :has_voted
				votes = votes - 1
			end
			@response.update_attributes(upvotes: votes)

			format.html { redirect_to :back }
		end
	end

	def downvote
		@response = Topic::Response.find(params[:id])
		respond_to do |format|
			status = session_downvote_status(@response.id)
			votes = @response.downvotes
			if status == :has_not_voted
				votes = votes + 1
			elsif status == :has_voted
				votes = votes - 1
			end
			@response.update_attributes(downvotes: votes)

			# if too many downvotes, this response will be reported
			if Float(@response.downvotes+1)/Float(@response.upvotes+1) > 10
				@response.update_attributes(reported: true)
			end

			format.html { redirect_to :back }
		end
	end

	def destroy
		@response = Topic::Response.find(params[:id])
		@response.destroy
		redirect_to :back
	end

	private

		def session_upvote_status(response_id)
			if session[:upvotes].nil?
				session[:upvotes] = { response_id => true }
				return :has_not_voted
			elsif not session[:upvotes][response_id]
				session[:upvotes][response_id] = true
				return :has_not_voted
			elsif session[:upvotes][response_id]
				session[:upvotes][response_id] = false
				return :has_voted
			end
		end


		def session_downvote_status(response_id)
			if session[:downvotes].nil?
				session[:downvotes] = { response_id => true }
				return :has_not_voted
			elsif not session[:downvotes][response_id]
				session[:downvotes][response_id] = true
				return :has_not_voted
			elsif session[:downvotes][response_id]
				session[:downvotes][response_id] = false
				return :has_voted
			end
		end


end
