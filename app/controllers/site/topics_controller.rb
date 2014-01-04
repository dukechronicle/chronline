class Site::TopicsController < Site::BaseController

	def show
		@topic = Topic.find(params[:id])
		@responses = @topic.responses.where('reported = ? OR approved = ?', false, true).order('created_at DESC')
		@responses = @responses.paginate(page: params[:page], per_page: 5)
	end

	def index
		@active_topics = Topic.where('archived = ?', false)
		@archived_topics = Topic.where('archived = ?', true)
	end

end
