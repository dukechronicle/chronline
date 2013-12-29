class Admin::ResponsesController < Admin::BaseController

	def destroy
		@response = Response.find(params[:id])
		@response.destroy
	end
end
