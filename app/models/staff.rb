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
  include ActiveModel::ForbiddenAttributesProtection
  include FriendlyId

  attr_accessible :affiliation, :biography, :columnist, :headshot_id, :name, :tagline, :twitter

  friendly_id :name, use: :slugged

  has_many :images, foreign_key: :photographer_id
  belongs_to :headshot, class_name: "Image"
  has_and_belongs_to_many :articles, join_table: :posts_authors,
    association_foreign_key: :post_id
  has_and_belongs_to_many :blog_posts, join_table: :posts_authors,
    association_foreign_key: :post_id, class_name: 'Blog::Post'

  validates :name, presence: true, uniqueness: true

  scope :search, ->(prefix) { where('name LIKE ?', "#{prefix}%") }
  scope :columnist, ->(bool) { where(columnist: (bool ? true : [false, nil])) }

  self.per_page = 25

  ###
  # Query scope for staff records who are photographers
  #
  def self.photographer(bool)
    self
      .joins('LEFT OUTER JOIN images ON staff.id = images.photographer_id')
      .group('staff.id')
      .having("COUNT(images.id) #{bool ? '>' : '='} 0")
  end

  def author?
    articles.present?
  end

  def blogger?
    blog_posts.present?
  end

  def last_name
    name.split.last
  end

  def photographer?
    images.present?
  end

  def self.find_or_create_all_by_name(names)
    staff = {}
    Staff.where(name: names).each do |member|
      staff[member.name] = member
    end
    names.each do |name|
      Staff.transaction do
        if not staff.has_key?(name)
          staff[name] = Staff.create!(name: name)
        end
      end
    end
    staff.values
  end
end
