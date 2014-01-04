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
		@response.update_attributes(upvotes: @response.upvotes + 1)
		redirect_to :back
	end

	def downvote
		@response = Topic::Response.find(params[:id])
		@response.update_attributes(downvotes: @response.downvotes + 1)
		redirect_to :back
	end

	def destroy
		@response = Topic::Response.find(params[:id])
		@response.destroy
		redirect_to :back
	end

end
