class Indexes < ActiveRecord::Migration
  def change
    add_index :articles, [:section, :created_at]
    add_index :articles, :slug, unique: true

    add_index :images, :date
    add_index :images, :photographer_id

    add_index :staff, :columnist
  end
end
