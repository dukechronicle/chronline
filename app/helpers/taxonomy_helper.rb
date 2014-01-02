module TaxonomyHelper

  def section_path(taxonomy, options = {})
    case taxonomy.taxonomy
    when :sections
      options[:section] = taxonomy.to_s[1..-1]
      site_article_section_path(options)
    when :blogs
      blog = Blog.find_by_taxonomy(taxonomy)
      if taxonomy.root?
        site_blogs_path(options)
      elsif blog && taxonomy[1]
        site_blog_category_path(blog, category: taxonomy[1].downcase)
      else
        site_blog_posts_path(blog)
      end
    end
  end

end
