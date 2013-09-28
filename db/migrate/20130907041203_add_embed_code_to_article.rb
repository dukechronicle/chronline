class AddEmbedCodeToArticle < ActiveRecord::Migration
  def change
  	add_column :articles, :embed_code, :string
  end
end
