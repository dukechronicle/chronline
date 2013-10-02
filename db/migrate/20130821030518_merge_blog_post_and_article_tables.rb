class MergeBlogPostAndArticleTables < ActiveRecord::Migration
  def change
    drop_table :blog_posts
    add_column :articles, :type, :string
    rename_table :articles_authors, :posts_authors
    rename_column :posts_authors, :article_id, :post_id
  end
end
