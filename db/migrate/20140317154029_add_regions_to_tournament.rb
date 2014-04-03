class AddRegionsToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :region0, :string
    add_column :tournaments, :region1, :string
    add_column :tournaments, :region2, :string
    add_column :tournaments, :region3, :string
  end
end
