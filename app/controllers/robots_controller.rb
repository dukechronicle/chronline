class RobotsController < ApplicationController

  def show
    output = "User-agent: *\n"
    Article.where(block_bots: true).find_each do |article|
      output = output+ "Disallow: /#{article.slug}\n"
      output = output+ "Disallow: /#{article.slug}/print\n"
    end

    render text: output, :content_type => "text/plain"
  end

end
