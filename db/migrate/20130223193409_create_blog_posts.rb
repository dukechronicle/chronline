class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.text :body
      t.string :blog
      t.string :title
      t.string :slug
      t.integer :image_id

      t.timestamps
    end

    add_index :blog_posts, :slug, unique: true
    add_index :blog_posts, [:blog, :created_at], unique: true
  end
end
