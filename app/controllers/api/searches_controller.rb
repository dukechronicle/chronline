class Api::SearchesController < ApplicationController

  def show
    search = Search.new(params)
    render json: search.results
  end

end
