class Poll < ActiveRecord::Base
  attr_accessible :description, :title, :section, :choice_ids

  has_many :choices, class_name: 'Poll::Choice', dependent: :destroy

  accepts_nested_attributes_for :choices

  validates :title, presence: true
end
