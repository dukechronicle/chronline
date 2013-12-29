class Admin::TopicsController < Admin::BaseController

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
	end

	def index
		@topics = Topic.all
	end

	def destroy
		@topic = Topic.find(params[:id])
		@topic.destroy
		redirect_to admin_topics_path
	end

end
