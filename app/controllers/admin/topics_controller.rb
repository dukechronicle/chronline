class Admin::TopicsController < Admin::BaseController
	helper_method :approve_toggle, :report_toggle

	def new
		@topic = Topic.new
	end

	def create
		@topic = Topic.new(params[:topic])
		if @topic.save
			redirect_to admin_topics_path
		else
			render 'new'
		end
	end

	def edit
		@topic = Topic.find(params[:id])
	end

	def update
		@topic = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic])
    	redirect_to admin_topics_path
    else
      render 'edit'
    end
  end

	def show
		@topic = Topic.find(params[:id])
		@responses = @topic.responses.order('created_at DESC')
		@responses = @responses.paginate(page: params[:page], per_page: 5)
	end

	def index
		@topics = Topic.all
	end

	def destroy
		@topic = Topic.find(params[:id])
		@topic.destroy
		redirect_to admin_topics_path
	end

	private

		def approve_toggle(approved)
			if approved
				return 'Remove Approval'
			else
				return 'Approve'
			end
		end

		def report_toggle(reported)
			if reported
				return 'Remove Reported'
			else
				return 'Report'
			end
		end

end
