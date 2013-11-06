class RemoveIdColumnsFromGalleriesAndPhotoshelterImages < ActiveRecord::Migration
  def up
    remove_column :galleries, :id
    remove_column :photoshelter_images, :id
  end

  def down
  end
end
