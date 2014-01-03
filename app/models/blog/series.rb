class Blog::Series < ActiveRecord::Base
  self.table_name = :blog_series

  belongs_to :image
  belongs_to :tag, class_name: 'ActsAsTaggableOn::Tag'

  validates :blog, presence: true
  validates :image, presence: true
  validates :tag, presence: true

  delegate :name, to: :tag

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
