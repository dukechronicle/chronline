class CreatePhotoshelterImages < ActiveRecord::Migration
  def change
    create_table :photoshelter_images do |t|
      t.string :pid
      t.string :gid

      t.timestamps
    end
  end
end
