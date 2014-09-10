module BaseSweeper

  def expire_obj_cache_with_taxonomies(obj)
    class_name = obj.class.name.parameterize(sep = '_').pluralize
    expire_fragment controller: "site/#{class_name}", action: :index, subdomain: :www
    obj.section.parents.each do |taxonomy|
      expire_fragment(
        controller: "site/#{class_name}",
        subdomain: :www,
        action: :index,
        section: taxonomy.to_s[1...-1]
      )
    end
    expire_fragment(
      id: obj,
      controller: "site/#{class_name}",
      action: :show,
      subdomain: :www,
    )
  end

end
