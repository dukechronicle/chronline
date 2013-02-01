class AddPreviousIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :previous_id, :string
  end
end
