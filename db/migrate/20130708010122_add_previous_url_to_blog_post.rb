class AddPreviousUrlToBlogPost < ActiveRecord::Migration
  def change
    add_column :blog_posts, :previous_url, :string
  end
end
