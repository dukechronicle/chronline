class Blog::Series < ActiveRecord::Base
  self.table_name = :blog_series

  belongs_to :image
  belongs_to :tag, class_name: 'ActsAsTaggableOn::Tag'
end

class ActsAsTaggableOn::Tag
  has_one :series, class_name: 'Blog::Series'
end
