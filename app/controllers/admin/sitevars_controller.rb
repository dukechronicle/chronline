class Admin::SitevarsController < Admin::BaseController
  def show
  end

  def update
    params[:sitevar].each do |var, val|
      Sitevar.send "#{var}=", val
    end
    redirect_to admin_configuration_path
  end
end
