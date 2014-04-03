class AddFeaturedToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :featured, :text
  end
end
