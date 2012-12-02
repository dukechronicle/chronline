# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  body       :text
#  subtitle   :string(255)
#  section    :string(255)
#  teaser     :string(255)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Article < ActiveRecord::Base
  attr_accessible :body, :subtitle, :section, :teaser, :title

  validates :body, presence: true
  validates :title, presence: true

  def render_body
    BlueCloth.new(body).to_html  # Uses bluecloth markdown renderer
  end

  def section
    Taxonomy.new(self[:section])
  end

  def section=(taxonomy)
    self[:section] = taxonomy.to_str
  end

end
