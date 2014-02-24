class AddOpinionToPosts < ActiveRecord::Migration
  def change
    add_column :articles, :opinion, :boolean, default: false
  end
end
