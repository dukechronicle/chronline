class Site::TopicResponsesController < Site::BaseController

	def create
		@response = Topic.find(params[:topic_id]).responses.build(params[:topic_response]) 
		if @response.save
			redirect_to :back
		else
			redirect_to :back
		end
	end

	def destroy
		@response = Response.find(params[:id])
		@response.destroy
	end
end
