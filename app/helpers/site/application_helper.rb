module Site::ApplicationHelper
  File.open(Rails.root.join("config", "ad_types.yml")) do |file|
    @@types = YAML::load(file)
  end

  def advertisement(zone, suffix = nil)
    zone = suffix ? "#{zone}_#{suffix}" : zone.to_s
    unit_id = '5382d6fe6c'
    page_id = '536870985'
    <<EOS
<script type="text/javascript">
    OX_#{unit_id}.showAdUnit(#{@@types[zone]['unit']});
</script>
<noscript>
  <iframe id="#{unit_id}" name="#{unit_id}" src="//ox-d.oncampusweb.com/w/1.0/afr?auid=#{@@types[zone]['unit']}&cb=#{Random.rand(99999999)}" frameBorder="0" frameSpacing="0" scrolling="no" width="#{@@types[zone]['width']}" height="#{@@types[zone]['height']}">
    <a href="//ox-d.oncampusweb.com/w/1.0/rc?cs=#{unit_id}&cb=#{Random.rand(99999999)}">
    <img src="//ox-d.oncampusweb.com/w/1.0/ai?auid=536871739&cs=#{unit_id}&cb=#{Random.rand(99999999)}" border="0" alt="">
    </a>
  </iframe>
</noscript>
EOS
      .html_safe
  end

  def frontpage?
    request.path == site_root_path
  end

end
