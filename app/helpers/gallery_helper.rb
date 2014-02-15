module GalleryHelper

  def photag_byline(gallery)
    photag_string = gallery.credit.split('/')[0].strip
    photag = get_staff_from_photag(photag_string)
    link_to photag.name, images_site_staff_path(photag)
  end

  def permanent_gallery_url(gallery)
    site_gallery_url(gallery.gid, subdomain: :www)
  end

  def get_staff_from_photag(photag)
    names = []
    names << photag
    photag = Staff.find_or_create_all_by_name(names)[0]
  end

  def image_info(image)
    credit = image.credit ? photag_byline(image) : ""
    "__credit__:#{credit}__caption__:#{image.caption} "
  end

  def mailto_gallery(gallery)
    subject = "Duke Chronicle: #{gallery.name}"
    body = <<EOS


--------------------------------------------------------------------------------

Duke Chronicle

#{gallery.name}

#{photag_byline(gallery)}

Visit #{site_gallery_url(gallery)} for the full gallery
EOS
  "mailto:?subject=#{subject}&body=#{URI.escape(body)}"
  end
end
