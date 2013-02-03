class Api::QdukeController < ApplicationController

  def frontpage
    page = Page.find_by_path('/')
    page.layout.generate_model
    render json: {
      layout: ActiveSupport::JSON.decode(page.layout_data),
      articles: page.layout.embedded.as_json(include: {image: {methods: :thumbnail_url}}),
    }
  end

end
