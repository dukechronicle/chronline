module GalleryHelper

  def photag_byline(gallery)
    photag_string = gallery.credit.split('/')[0].strip
    photag = get_staff_from_photag(photag_string)
    link_to photag.name, images_site_staff_path(photag)
  end

  def get_staff_from_photag(photag)
    names = []
    names << photag
    photag = Staff.find_or_create_all_by_name(names)[0]
  end
end
