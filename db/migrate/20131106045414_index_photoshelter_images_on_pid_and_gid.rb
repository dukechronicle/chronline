class IndexPhotoshelterImagesOnPidAndGid < ActiveRecord::Migration
  def up
    add_index :photoshelter_images, [:gid, :pid], :unique => true
  end

  def down
    remove_index :photoshelter_images, [:gid, :pid], :unique => true
  end
end
