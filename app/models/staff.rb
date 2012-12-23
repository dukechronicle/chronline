class Staff < ActiveRecord::Base
  attr_accessible :affiliation, :biography, :columnist, :name, :tagline, :twitter

  validates :name, presence: true

  SEARCH_LIMIT = 10


  def self.search(name)
    self.limit(SEARCH_LIMIT).where('name LIKE ?', "#{name}%")
  end
end

class Author < Staff
  has_and_belongs_to_many :articles

  def self.find_or_create_all_by_name(names)
    authors = {}
    Author.where(name: names).each do |author|
      authors[author.name] = author
    end
    names.each do |name|
      Author.transaction do
        if not authors.has_key?(name)
          authors[name] = Author.create(name: name)
        end
      end
    end
    authors.values
  end
end

class Photographer < Staff
  has_many :images
end
