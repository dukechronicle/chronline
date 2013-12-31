module Site::ApplicationHelper

  def advertisement(zone, suffix = nil)
    zone = "#{zone}_#{suffix}" if suffix
    <<EOS
<script type='text/javascript'><!--// <![CDATA[
    OA_show('#{zone}');
// ]]> --></script>
EOS
      .html_safe
  end

  def frontpage?
    request.path == site_root_path
  end

end
