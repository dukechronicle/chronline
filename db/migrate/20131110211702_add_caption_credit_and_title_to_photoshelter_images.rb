class AddCaptionCreditAndTitleToPhotoshelterImages < ActiveRecord::Migration
  def change
    add_column :photoshelter_images, :caption, :text
    add_column :photoshelter_images, :credit, :string
    add_column :photoshelter_images, :title, :string
  end
end
