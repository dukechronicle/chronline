class AddSlugToStaff < ActiveRecord::Migration
  def change
    add_column :staff, :slug, :string
    add_index :staff, :slug, unique: true
    add_index :staff, :name, unique: true
  end
end
