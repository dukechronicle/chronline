module Postable

  def self.included(base)
    base.send(:include, FriendlyId)
    base.attr_accessible :image_id, :title
    base.friendly_id(:title, use: [:slugged, :history])
    base.belongs_to :image
  end

end
