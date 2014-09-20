xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom",
  "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.tag! "atom:link", href: url_for(only_path: false), rel: "self", type: "application/rss+xml"
    xml.title title(@taxonomy)
    xml.link site_root_url(subdomain: 'www')
    xml.description "The Independent Daily at Duke University"
    xml.language "en-us"
    xml.copyright "Copyright 2012 Duke Student Publishing Company. All rights reserved."
    xml.image do
      xml.url "http:#{image_path('logo/300x300.png')}"
      xml.title title(@taxonomy)
      xml.link site_root_url(subdomain: 'www')
    end

    @articles.each do |article|
      xml.item do
        xml.guid site_article_url(article, subdomain: 'www')
        xml.title article.title
        xml.link site_article_url(article, subdomain: 'www')
        xml.description article.body_text
        xml.tag!("dc:creator", byline(article))
        xml.pubDate article.published_at.rfc822
        xml.comments site_article_url(article, subdomain: 'www') + '#disqus_thread'
        if article.image
          xml.enclosure(url: URI.join(site_root_url(subdomain: 'www'), article.image.original.url(:rectangle_636x)),
                        length: article.image.original_file_size,
                        type: article.image.original_content_type)
        end
      end
    end
  end
end
