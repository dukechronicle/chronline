class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.text :body
      t.string :subtitle
      t.string :section
      t.string :teaser
      t.string :title

      t.timestamps
    end
  end
end
