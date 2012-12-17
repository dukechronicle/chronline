class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :caption
      t.string :location
      t.string :original

      t.timestamps
    end
  end
end
