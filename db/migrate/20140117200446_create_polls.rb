class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title
      t.string :description
      t.string :section

      t.timestamps
    end
  end
end
