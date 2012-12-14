class CreateStaff < ActiveRecord::Migration
  def change
    create_table :staff do |t|
      t.string :affiliation
      t.text :biography
      t.boolean :columnist
      t.string :name
      t.string :tagline
      t.string :twitter
      t.string :type

      t.timestamps
    end
  end
end
