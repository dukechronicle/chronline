module Site::AdvertisementHelper
  File.open(Rails.root.join("config", "ad_types.yml")) do |file|
    AD_UNITS = YAML::load(file)
  end

  GROUP_ID = '5382d6fe6c'

  def advertisement(zone, suffix = nil)
    zone = suffix ? "#{zone}_#{suffix}" : zone.to_s
    page_id = '536870985'
    a_random = Random.rand(99999999)
    <<EOS
<script type="text/javascript">
    OX_#{GROUP_ID}.showAdUnit(#{AD_UNITS[zone]['unit']});
</script>
<noscript>
  <iframe id="#{GROUP_ID}" name="#{GROUP_ID}" src="//ox-d.oncampusweb.com/w/1.0/afr?auid=#{AD_UNITS[zone]['unit']}&cb=#{a_random}" frameBorder="0" frameSpacing="0" scrolling="no" width="#{AD_UNITS[zone]['width']}" height="#{AD_UNITS[zone]['height']}">
    <a href="//ox-d.oncampusweb.com/w/1.0/rc?cs=#{GROUP_ID}&cb=#{a_random}">
    <img src="//ox-d.oncampusweb.com/w/1.0/ai?auid=#{AD_UNITS[zone]['unit']}&cs=#{GROUP_ID}&cb=#{a_random}" border="0" alt="">
    </a>
  </iframe>
</noscript>
EOS
      .html_safe
  end

  def ad_group_id
    GROUP_ID
  end
end
