class Page < ActiveRecord::Base
  attr_accessible :model, :path, :template, :title

  validates :path, presence: true
  validates :title, presence: true, uniqueness: true,
  validates :title, format: {with: /^\/[a-z0-9\_\.\-\/]*$/, message: 'Must be a URL path'}
  validates :template, presence: true

end
