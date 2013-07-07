module Site::ApplicationHelper

  def advertisement(zone)
    <<EOS
<script type='text/javascript'><!--// <![CDATA[
    OA_show('#{zone.to_s}');
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
