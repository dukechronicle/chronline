class Topic < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_many :responses, class_name: 'Topic::Response', dependent: :destroy

  attr_accessible :title, :description, :archived

  validates :title, presence: true
end
