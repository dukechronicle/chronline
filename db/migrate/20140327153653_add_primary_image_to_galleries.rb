class AddPrimaryImageToGalleries < ActiveRecord::Migration
  def change
    add_column :galleries, :primary_image_id, :string
  end
end
