module Site::ApplicationHelper

  def advertisement(zone, suffix = nil)
    zone = "#{zone}_#{suffix}" if suffix
    <<EOS
<script type="text/javascript">
    OX_9a3d33b961.showAdUnit(OX_units['#{zone}']);
</script>
<noscript>
  <iframe id="9a3d33b961" name="9a3d33b961" src="http://ox-d.oncampusweb.com/w/1.0/afr?auid=536871739&cb=420247" frameBorder="0" frameSpacing="0" scrolling="no" width="728" height="90">
    <a href="http://ox-d.oncampusweb.com/w/1.0/rc?cs=9a3d33b961&cb=420247">
    <img src="http://ox-d.oncampusweb.com/w/1.0/ai?auid=536871739&cs=9a3d33b961&cb=420247" border="0" alt="">
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
