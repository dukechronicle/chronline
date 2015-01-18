class RobotsController < ApplicationController

  def show
    output = "User-agent: *\n"
    Article.where(block_bots: true).find_each do |article|
      article.slugs.each do |s|
        output += "Disallow: /#{s.slug}\n"
        output += "Disallow: /#{s.slug}/print\n"
      end
    end
    render text: output, :content_type => "text/plain"
  end

end
