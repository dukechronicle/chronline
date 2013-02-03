class AddCreditToImages < ActiveRecord::Migration
  def change
    add_column :images, :credit, :string
  end
end
