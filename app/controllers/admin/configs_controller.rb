class Admin::ConfigsController < Admin::BaseController
  def show
    @issuu = $redis.get('issuu')
  end

  def update
    $redis.set('issuu', params[:issuu])
    redirect_to admin_config_path
  end
end
