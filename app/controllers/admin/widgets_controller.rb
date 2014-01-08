class Admin::WidgetsController < Admin::BaseController
  def index
  end

  def match_url
    render json: {tag: Post::EmbeddedMedia.match_url_to_tag(params[:url]).to_s}
  end
end
