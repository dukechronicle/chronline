class AddPhotographerToImages < ActiveRecord::Migration
  def change
    add_column :images, :photographer_id, :integer
  end
end
