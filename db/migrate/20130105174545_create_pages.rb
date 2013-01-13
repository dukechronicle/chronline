class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.text :layout_data
      t.string :layout_template
      t.string :path
      t.string :title

      t.timestamps
    end
    add_index :pages, :path, unique: true
  end
end
