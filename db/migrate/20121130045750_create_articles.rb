class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.text :body
      t.string :subtitle
      t.string :taxonomy
      t.string :teaser
      t.string :title

      t.timestamps
    end
  end
end
