class Api::TopicResponsesController < Api::BaseController
  REPORT_LIMIT = 10

  def index
    @topic = Topic.find(params[:topic_id])
    if @topic
      @responses = @topic.responses
        .where("reported = false OR approved = true")
        .order('created_at DESC')
        .paginate(page: params[:page], per_page: 30)
      respond_with_topic_responses @responses, status: :ok
    else
      respond_with status: :unprocessable_entity
    end
  end

  def create
    response_params = params[:topic_response]
    @response = Topic.find(params[:topic_id]).responses.build(response_params)
    if !verify_recaptcha
      respond_with "reCAPTCHA failure", status: :forbidden
    end
    if !@response.save
      respond_with @response.errors, status: :unprocessable_entity
    else
      respond_with_topic_response @response, status: :created
    end
  end

  def upvote
    @response = Topic::Response.find(params[:id])
    status = session_upvote_status(@response.id)
    votes = @response.upvotes
    status ? votes = votes - 1 : votes = votes + 1
    @response.upvotes = votes
    @response.save
    respond_with_topic_response @response, status: :ok
  end

  def downvote
    @response = Topic::Response.find(params[:id])
    status = session_downvote_status(@response.id)
    votes = @response.downvotes
    status ? votes = votes - 1 : votes = votes + 1
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

  def handle_unverified_request
    head :forbidden and return
  end

  private
  def report_helper
    if session[:reports].nil?
      session[:reports] = 1
    else
      session[:reports] = session[:reports] + 1
    end
    if session[:reports] > REPORT_LIMIT
      return false
    end
    return true
  end

  def session_upvote_status(response_id)
    return session_status_helper(response_id, :upvotes)
  end

  def session_downvote_status(response_id)
    return session_status_helper(response_id, :downvotes)
  end

  # false means has not voted
  def session_status_helper(response_id, up_or_down)
    votestatus = votes_hashparam(response_id, up_or_down)
    if session[votestatus].nil? or not session[votestatus]
      session[votestatus] = true
      return false
    else
      session[votestatus] = false
      return true
    end
  end

  def votes_hashparam(response_id, option)
    (option.to_s + "_" + response_id.to_s).to_sym
  end

  # for multiple responses
  def respond_with_topic_responses(responses, options = {})
    options.merge!(
      properties: {
        upvoted: ->(response) {
          session[votes_hashparam(response.id, :upvotes)] ||= false
        },
        downvoted: ->(response) {
          session[votes_hashparam(response.id, :downvotes)] ||= false
        },
        reports: ->(response) {
          session[:reports] ||= 0
        },
      }
    )
    respond_with responses, options
  end

  # for a single Topic::Response
  def respond_with_topic_response(response, options = {})
    response_hash = response.as_json
    params = {
      upvoted: session[votes_hashparam(response.id, :upvotes)] ||= false,
      downvoted: session[votes_hashparam(response.id, :downvotes)] ||= false,
      reports: session[:reports] ||= 0
    }
    response_hash.merge!(params)
    render json: response_hash, status: options[:status]
  end
end
