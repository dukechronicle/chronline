require 'will_paginate/array'

class Api::TaxonomyController < Api::BaseController

  def index
    sections = Taxonomy.nodes
    blogs = Blog.nodes
    nodes = (sections + blogs).paginate(
      page: params[:page],
      per_page: params[:limit]
    )
    render json: nodes
  end

end
