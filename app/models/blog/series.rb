class Blog::Series < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  self.table_name = :blog_series

  # HAX: needed so that url_for works correctly for blog posts
  # self.model_name.instance_variable_set(:@singular_route_key, 'series')
  # self.model_name.instance_variable_set(:@route_key, 'series')

  belongs_to :image
  belongs_to :tag, class_name: 'ActsAsTaggableOn::Tag'

  validates :blog, presence: true
  validates :image, presence: true
  validates :tag, presence: true

  def name
    tag.try(:name)
  end

  def name=(name)
    self.tag = ActsAsTaggableOn::Tag.find_or_create_with_like_by_name(name)
  end

  def blog
    Blog.find_by_id(blog_id)
  end

  def blog=(blog)
    self.blog_id =
      if blog
        blog.id
      end
  end
end

class ActsAsTaggableOn::Tag
  has_one :series, class_name: 'Blog::Series'
end
