class AddDateToImage < ActiveRecord::Migration
  def change
    add_column :images, :date, :date
  end
end
