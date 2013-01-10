# == Schema Information
#
# Table name: staff
#
#  id          :integer          not null, primary key
#  affiliation :string(255)
#  biography   :text
#  columnist   :boolean
#  name        :string(255)
#  tagline     :string(255)
#  twitter     :string(255)
#  type        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string(255)
#

class Staff < ActiveRecord::Base
  include FriendlyId

  SEARCH_LIMIT = 10

  attr_accessible :affiliation, :biography, :columnist, :name, :tagline, :twitter

  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: true


  def self.search(name)
    self.limit(SEARCH_LIMIT).where('name LIKE ?', "#{name}%")
  end

  # Fixes problem with subclass route helpers
  # http://www.christopherbloom.com/2012/02/01/notes-on-sti-in-rails-3-0/
  def self.inherited(child)
    child.instance_eval do
      alias :original_model_name :model_name
      def model_name
        Staff.model_name
      end
    end
    super
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
