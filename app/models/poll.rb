class Poll < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  extend HasTaxonomy

  attr_accessible :description, :title, :section, :choice_ids, :archived

  has_many :choices, class_name: 'Poll::Choice', dependent: :destroy

  has_taxonomy(:section, :sections)

  accepts_nested_attributes_for :choices

  validates :title, presence: true

  default_scope { where(archived: false) }

  self.per_page = 25
end
