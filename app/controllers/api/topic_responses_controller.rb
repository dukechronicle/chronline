class Api::TopicResponsesController < Api::BaseController
  REPORT_LIMIT = 10

  def index
    @topic = Topic.find(params[:topic_id])
    @responses = @topic.responses
      .order('created_at DESC')
      .paginate(page: params[:page], per_page: 30)
    respond_with_topic_responses @responses
  end

  def create
    @response = Topic.find(params[:topic_id]).responses.build(params[:topic_response])
    if !verify_recaptcha
      render json: "reCAPTCHA failure", status: :forbidden
    elsif @response.save
      respond_with_topic_response @response, status: :created
    else
      respond_with @response.errors, status: :unprocessable_entity
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
    @response.upvotes = votes
    @response.save
    respond_with_topic_response @response, status: :ok
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
    @response.downvotes = votes

    # if too many downvotes, this response will be reported
    if Float(@response.downvotes+1)/Float(@response.upvotes+1) > 10
      @response.reported = true
    end
    @response.save
    respond_with_topic_response @response, status: :ok
  end

  def report
    if !report_helper
      respond_with "Report limited exceeded.", status: :forbidden
    else
      @response = Topic::Response.find(params[:id])
      @response.reported = true
      @response.save
      respond_with_topic_response @response, status: :ok
    end
  end

  def destroy
    @response = Topic::Response.find(params[:id])
    @response.destroy
    respond_with status: :ok
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

  # for multiple responses
  def respond_with_topic_responses(responses, options = {})
    options.merge!(
      properties: {
        upvoted: ->(response) {
          (upvotes = session[:upvotes]).nil? ? false : upvotes[response.id]
        },
        downvoted: ->(response) {
          (downvotes = session[:downvotes]).nil? ? false : downvotes[response.id]
        },
        reported: ->(response) {
          (reported = session[:reported]).nil? ? false : reported[response.id]
        },
      }
    )
    respond_with responses, options
  end

  # for a single Topic::Response
  def respond_with_topic_response(response, options = {})
    response_hash = response.as_json
    params = {
      upvoted: (upvotes = session[:upvotes]).nil? ? false : upvotes[response.id],
      downvoted: (downvotes = session[:downvotes]).nil? ? false : downvotes[response.id],
      reported: (reported = session[:reported]).nil? ? false : reported[response.id]
    }
    response_hash.merge!(params)
    render json: response_hash, status: options[:status]
  end
end
