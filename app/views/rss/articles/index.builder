xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "The Chronicle"
    xml.link site_root_url(subdomain: 'www')
    xml.description "The Independent Daily at Duke University"
    xml.language "en-us"
    xml.copyright "Copyright 2012 Duke Student Publishing Company. All rights reserved."
    xml.image do
      xml.url "http:#{image_path('logo/300x300.png')}"
      xml.title "The Chronicle"
      xml.link site_root_url(subdomain: 'www')
    end
  end
end
