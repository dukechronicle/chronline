class AddBlockBotsColumnToPostable < ActiveRecord::Migration
  def change
    add_column :articles, :block_bots, :boolean, default: false
    add_column :blog_posts, :block_bots, :boolean, default: false
  end
end
