class Blog
  class Post < ActiveRecord::Base
    include Postable

    self.table_name = :blog_posts

    attr_accessible :blog

    validates :blog, presence: true
  end
end
