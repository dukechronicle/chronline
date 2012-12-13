class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
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
