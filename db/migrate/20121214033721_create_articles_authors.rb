class CreateArticlesAuthors < ActiveRecord::Migration
  def change
    create_table :articles_authors do |t|
      t.integer :article_id
      t.integer :author_id
    end

    add_index :articles_authors, :article_id
    add_index :articles_authors, :author_id
    add_index :articles_authors, [:article_id, :author_id], unique: true
  end
end
