require 'has_taxonomy'

class Poll < ActiveRecord::Base
  extend HasTaxonomy

  attr_accessible :description, :title, :section, :choice_ids

  has_many :choices, class_name: 'Poll::Choice', dependent: :destroy

  has_taxonomy

  accepts_nested_attributes_for :choices

  validates :title, presence: true
end
