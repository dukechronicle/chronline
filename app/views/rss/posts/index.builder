xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.tag! "atom:link", href: url_for(only_path: false), rel: "self", type: "application/rss+xml"
    xml.title title(@taxonomy)
    xml.link site_root_url(subdomain: 'www')
    xml.description "The Independent Daily at Duke University"
    xml.language "en-us"
    xml.copyright "Copyright #{Date.today.year} Duke Student Publishing Company. All rights reserved."
    xml.image do
      xml.url "http:#{image_path('logo/300x300.png')}"
      xml.title title(@taxonomy)
      xml.link site_root_url(subdomain: 'www')
    end

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.link site_post_url(post, subdomain: 'www')
        xml.description post.render_body
        xml.author byline(post)
        xml.pubDate post.published_at.rfc822
        xml.comments site_post_url(post, subdomain: 'www') + '#disqus_thread'
        if post.image
          xml.enclosure(
            url: post.image.original.url(:rectangle_636x),
            length: post.image.original_file_size,
            type: post.image.original_content_type
          )
        end
      end
    end
  end
end
