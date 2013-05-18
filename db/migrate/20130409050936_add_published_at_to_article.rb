class AddPublishedAtToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :published_at, :datetime
    add_index :articles, [:section, :published_at]
    remove_index :articles, [:section, :created_at]
  end
end
