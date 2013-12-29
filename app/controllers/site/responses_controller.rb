class Site::ResponsesController < Site::BaseController

	def destroy
		@response = Response.find(params[:id])
		@response.destroy
	end
end
