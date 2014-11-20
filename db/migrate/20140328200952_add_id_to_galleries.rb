class AddIdToGalleries < ActiveRecord::Migration
  def change
    drop_table :galleries
    create_table :galleries do |t|
      t.string :gid 
      t.string :name
      t.string :slug, unique: true
      t.text :description
      t.date :date
      t.string :primary_image_id
    end

    add_column :gallery_images, :gallery_id, :integer
  end
end
