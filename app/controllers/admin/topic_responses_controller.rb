class Admin::TopicResponsesController < Admin::BaseController

  def create
    @response = Topic.find(params[:topic_id]).responses.build(params[:topic_response])
    @response.approved = true
    if @response.save
      # some message?
    end
    redirect_to :back
  end

  def report
    @response = Topic::Response.find(params[:id])
    @response.reported = !@response.reported
    @response.save
    redirect_to :back
  end

  def approve
    @response = Topic::Response.find(params[:id])
    @response.approved = !@response.approved
    redirect_to :back
  end

  def destroy
    @response = Topic::Response.find(params[:id])
    @response.destroy
    redirect_to :back
  end

end
