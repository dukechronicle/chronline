class Gallery < ActiveRecord::Base
  attr_accessible :name, :pid

  validates :name, presence: true
  validates :pid, presence: true, uniqueness: true
end
