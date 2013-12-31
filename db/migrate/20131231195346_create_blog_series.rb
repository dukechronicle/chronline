class CreateBlogSeries < ActiveRecord::Migration
  def change
    create_table :blog_series do |t|
      t.integer :tag_id
      t.integer :image_id

      t.timestamps
    end
  end
end
