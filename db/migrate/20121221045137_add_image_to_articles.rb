class AddImageToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :image_id, :integer
  end
end
