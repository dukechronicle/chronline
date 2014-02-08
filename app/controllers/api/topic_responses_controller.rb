class Api::TopicResponsesController < Api::BaseController

  REPORT_LIMIT = 10

  def index
    @topic = Topic.find(params[:topic_id)])
    @responses = @topic.responses.order('created_at DESC').paginate(page: params[:page], per_page: 30)
    respond_with @responses, status: :success
  end

  def create
    @response = Topic.find(params[:topic_id]).responses.build(params[:topic_response])
    if !verify_recaptcha
      respond_with "reCAPTCHA failure", status: :forbidden
    if !@response.save
      respond_with @response.errors, status: :unprocessable_entity
    else
      respond_with @response, status: :created
    end
  end

  def upvote
    @response = Topic::Response.find(params[:id])
    status = session_upvote_status(@response.id)
    votes = @response.upvotes
    if status == :has_not_voted
      votes = votes + 1
    elsif status == :has_voted
      votes = votes - 1
    end
    @response.update_attributes(upvotes: votes)
    end
    respond_with @response, status: :success
  end

  def downvote
    @response = Topic::Response.find(params[:id])
    status = session_downvote_status(@response.id)
    votes = @response.downvotes
    if status == :has_not_voted
      votes = votes + 1
    elsif status == :has_voted
      votes = votes - 1
    end
    @response.update_attributes(downvotes: votes)

    # if too many downvotes, this response will be reported
    if Float(@response.downvotes+1)/Float(@response.upvotes+1) > 10
      @response.update_attributes(reported: true)
    end
    respond_with @response, status: :success
  end

  def report
    if !report_helper
      respond_with "Report limited exceeded.", status: :forbidden
    else
      @response = Topic::Response.find(params[:id])
      @response.update_attributes(reported: true)
      respond_with @response, status: :success
  end

  def destroy
    @response = Topic::Response.find(params[:id])
    @response.destroy
    respond_with status: :success
  end

  private

    def report_helper
      if session[:reported].nil?
        session[:reported] = 1
      else
        session[:reported] = session[:reported] + 1
      end
      if session[:reported] > REPORT_LIMIT
        return false
      end
      return true
    end

    def session_upvote_status(response_id)
      if session[:upvotes].nil?
        session[:upvotes] = { response_id => true }
        return :has_not_voted
      elsif not session[:upvotes][response_id]
        session[:upvotes][response_id] = true
        return :has_not_voted
      elsif session[:upvotes][response_id]
        session[:upvotes][response_id] = false
        return :has_voted
      end
    end

    def session_downvote_status(response_id)
      if session[:downvotes].nil?
        session[:downvotes] = { response_id => true }
        return :has_not_voted
      elsif not session[:downvotes][response_id]
        session[:downvotes][response_id] = true
        return :has_not_voted
      elsif session[:downvotes][response_id]
        session[:downvotes][response_id] = false
        return :has_voted
      end
    end

end
