class Beta::BaseController < ApplicationController
  layout 'beta'

  def custom_page
    @page = Page.find_by_path!(request.path)
    @model = promise { @page.layout.model }
    @title = @page.title
    @description = @page.description
    render "beta/pages/#{@page.layout_template.to_s.underscore}"
  end

  def not_found
    render 'beta/404', status: :not_found
  end

end
