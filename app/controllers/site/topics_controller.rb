class Site::TopicsController < Site::BaseController

	def show
		@topic = Topic.find(params[:id])
		@response = Response.new
	end

	def index
		@topics = Topic.all
	end

end
