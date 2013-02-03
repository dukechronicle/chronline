class ArticlesStaffTable < ActiveRecord::Migration
  def change
    rename_column :articles_authors, :author_id, :staff_id
  end
end
