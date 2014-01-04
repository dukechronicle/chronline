class Site::TopicsController < Site::BaseController

	def show
		@topic = Topic.find(params[:id])
		@responses = @topic.responses.where('reported = ? OR approved = ?', false, true).order('created_at DESC')
		@responses = @responses.paginate(page: params[:page], per_page: 5)
	end

	def index
		@topics = Topic.all
	end

end
