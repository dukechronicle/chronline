class EnhancePages < ActiveRecord::Migration
  def change
    add_column :pages, :description, :string
    add_column :pages, :image_id, :integer
  end
end
