module TaxonomyHelper

  def section_path(taxonomy, options={})
    options[:section] = taxonomy.to_s[1..-1]
    site_article_section_path(options)
  end

end
