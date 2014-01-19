class Poll::Choice < ActiveRecord::Base
  attr_accessible :poll_id, :title, :votes

  belongs_to :poll

  validates :title, presence: true
end
