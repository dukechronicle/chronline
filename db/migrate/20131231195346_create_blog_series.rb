class CreateBlogSeries < ActiveRecord::Migration
  def change
    create_table :blog_series do |t|
      t.integer :tag_id
      t.integer :image_id
      t.string :blog_id

      t.timestamps
    end

    add_index :blog_series, :tag_id
  end
end
