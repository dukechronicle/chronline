class Site::TopicsController < Site::BaseController

	def show
		@thisTopic = Topic.find(params[:id])
	end

	def index
		@allTopics = Topics.all
	end

end
