class Site::TopicsController < Site::BaseController

	def show
		@topic = Topic.find(params[:id])
	end

	def index
		@topics = Topic.all
	end

end
