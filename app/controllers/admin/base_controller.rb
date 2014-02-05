class Admin::BaseController < ApplicationController
  layout 'admin'

  before_filter :authenticate_admin!
end
