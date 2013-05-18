class AddPublishedAtToBlogPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :published_at, :datetime
    add_index :blog_posts, [:blog, :published_at]
    remove_index :blog_posts, [:blog, :created_at]
  end
end
