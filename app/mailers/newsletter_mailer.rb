class NewsletterMailer < ActionMailer::Base
  helper PostHelper

  def article(article)
    @article = article
    mail
  end

  def daily(model)
    @model = model
    mail
  end

  def featured(article)
    @article = article
    mail
  end

  def advertisement(href, image_src)
    @href = href
    @image_src = image_src
    mail
  end

  def header_image(image_path, alt)
    @image_path = image_path
    @alt = alt
    mail
  end
end
