class Staff < ActiveRecord::Base
  attr_accessible :affiliation, :biography, :columnist, :name, :tagline, :twitter

  validates :name, presence: true
end

class Author < Staff
  has_and_belongs_to_many :articles
end
