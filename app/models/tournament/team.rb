class Tournament::Team < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  attr_accessible :espn_id, :mascot, :region_id, :seed, :shortname, :school,
    :preview, :article_id

  belongs_to :tournament
  belongs_to :article

  before_validation { self.shortname ||= self.school }

  validates :school, presence: true
  validates :mascot, presence: true
  validates :shortname, presence: true
  validates :mascot, presence: true
  validates :seed, presence: true,
    numericality: { greater_than: 0, less_than_or_equal_to: 16 }
  validates :region_id, presence: true,
    numericality: { greater_than_or_equal_to: 0, less_than: 4 }
  validates :tournament, presence: true

  def region
    tournament.send("region#{region_id}")
  end
end
