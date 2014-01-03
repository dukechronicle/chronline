class Site::ResponsesController < Site::BaseController

	def create
		@response = Response.new(params[:response])
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
