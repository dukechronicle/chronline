module Site::AdvertisementHelper
  AD_UNITS = YAML::load_file(Rails.root.join("config", "ad_types.yml"))

  GROUP_ID = '5382d6fe6c'

  def advertisement(zone, suffix = nil)
    zone = suffix ? "#{zone}_#{suffix}" : zone.to_s
    page_id = '536870985'
    render(
      partial: 'beta/partials/advertisement_tag', layout: false, locals: {
        group_id: GROUP_ID,
        unit: AD_UNITS[zone]['unit'],
        width: AD_UNITS[zone]['width'],
        height: AD_UNITS[zone]['height'],
        a_random: Random.rand(99999999),
      }
    ).html_safe
  end

  def ad_group_id
    GROUP_ID
  end
end
