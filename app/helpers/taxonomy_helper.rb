module TaxonomyHelper

  def section_path(taxonomy, options={})
    blog = Blog.find_by_taxonomy(taxonomy)
    if blog && taxonomy[2]
      site_blog_category_path(blog, category: taxonomy[2].downcase)
    elsif blog
      site_blog_posts_path(blog)
    elsif taxonomy == Taxonomy['Blogs']
      site_blogs_path(options)
    else
      options[:section] = taxonomy.to_s[1..-1]
      site_article_section_path(options)
    end
  end

end
