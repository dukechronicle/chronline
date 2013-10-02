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

  def datetime_tag(datetime, format, options = {})
    data = { format: format }
    data[:timestamp] = 'true' if options[:timestamp]
    content_tag(:time, nil, datetime: datetime.iso8601, class: options[:class],
                data: data)
  end

  def frontpage?
    request.path == site_root_path
  end

end
