class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.string :pid, :primary_key => true
      t.string :name

      t.timestamps
    end
  end
end
