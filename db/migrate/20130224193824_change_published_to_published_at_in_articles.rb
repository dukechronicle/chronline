class ChangePublishedToPublishedAtInArticles < ActiveRecord::Migration
  def up
    remove_column :articles, :published
    add_column :articles, :published_at, :datetime, default: nil
  end

  def down
    remove_column :articles, :published_at
    add_column :articles, :published, :boolean
  end
end
