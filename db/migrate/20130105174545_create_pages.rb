class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.text :model
      t.string :path
      t.string :title
      t.string :template

      t.timestamps
    end
    add_index :pages, :path, unique: true
  end
end
