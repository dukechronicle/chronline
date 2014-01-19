class Poll < ActiveRecord::Base
  attr_accessible :description, :title, :section

  has_many :choices, class_name: 'Poll::Choice', dependent: :destroy

  validates :title, presence: true
end
