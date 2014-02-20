module Site::ApplicationHelper
  def frontpage?
    request.path == site_root_path
  end
end
