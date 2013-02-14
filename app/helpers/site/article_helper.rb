module Site::ArticleHelper

  def photo_credit(image, options={})
    if image.photographer
      name = if options[:include_link]
               link_to(image.photographer.name,
                       site_staff_path(image.photographer))
             else
               image.photographer.name
             end
      if image.attribution.blank?
        name
      else
        image.attribution.sub('?', name)
      end.html_safe
    elsif image.credit
      image.credit
    end
  end

end
