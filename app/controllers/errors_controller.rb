class ErrorsController < ApplicationController
  def not_found
    template, layout, @back = case request.subdomain.to_sym
      when :m then ['errors/404m', 'layouts/mobile', mobile_root_path]
      else ['errors/404', 'layouts/site', site_root_path]
      end

    render template, layout: layout
  end
end
