class AddDetailsToGalleries < ActiveRecord::Migration
  def change
    add_column :galleries, :description, :text
    add_column :galleries, :section, :string
  end
end
