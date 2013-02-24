class BlogPost < ActiveRecord::Base
  include Postable

  attr_accessible :blog

  validates :blog, presence: true

end
