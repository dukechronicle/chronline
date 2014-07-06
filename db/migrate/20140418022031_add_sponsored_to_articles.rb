class AddSponsoredToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :sponsored_post, :boolean, default: false
  end
end
