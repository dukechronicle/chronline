require 'will_paginate/array'

class Api::TaxonomyController < Api::BaseController

  def index
    sections = Taxonomy.nodes.paginate(
      page: params[:page],
      per_page: params[:limit]
    )
    render json: sections
  end

end
