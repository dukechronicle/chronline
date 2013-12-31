class CreateGalleriesAndGalleryImages < ActiveRecord::Migration
  def change
    create_table :galleries, id: false do |t|
      t.string :gid, primary_key: true
      t.string :name
      t.text :description

      t.timestamps
    end

    create_table :gallery_images, id: false do |t|
      t.string :pid, :primary_key => true
      t.string :gid
      t.text :caption
      t.string :credit
      t.string :title

      t.timestamps
    end

    add_index :gallery_images, [:gid, :pid], unique: true
  end
end
