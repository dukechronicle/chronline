class Site::ContributorsController < Site::BaseController
  def index
    @contributors = Contributor.all
  end
end
