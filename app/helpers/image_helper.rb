module ImageHelper

  def image_attributions

  end

  def photo_credit(image, options={})
    if image.photographer
      name = (options[:link] ?
              link_to(image.photographer.name,
                      images_site_staff_path(image.photographer)) :
              image.photographer.name)
      if image.attribution.blank?
        name
      else
        image.attribution.sub('?', name)
      end.html_safe
    elsif image.credit
      image.credit
    end
  end

  def associated_url(image)
    if image.articles.present?
      site_article_path image.articles.last
    else
      image.original.url
    end
  end

  def cropped_image_tag(image, style, options = {})
    options[:alt] = image.caption
    if (match = image.original.styles[style].geometry.match(/\d+x\d+/) and
        (options.keys & [:width, :height, :size]).empty?)
      options[:size] = match[0]
    end
    image_tag image.original.url(style), options
  end

end
