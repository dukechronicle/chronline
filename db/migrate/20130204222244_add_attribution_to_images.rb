class AddAttributionToImages < ActiveRecord::Migration
  def change
    add_column :images, :attribution, :string
  end
end
