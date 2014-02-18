class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.string :event
      t.datetime :start_date
      t.string :slug

      t.timestamps
    end

    add_index :tournaments, :slug, unique: true
  end
end
