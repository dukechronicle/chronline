class CreateTournamentTeams < ActiveRecord::Migration
  def change
    create_table :tournament_teams do |t|
      t.string :school
      t.string :shortname
      t.string :mascot
      t.integer :seed
      t.integer :region_id
      t.integer :espn_id
      t.integer :tournament_id

      t.timestamps
    end

    add_index :tournament_teams, [:tournament_id, :region_id, :seed], unique: true
  end
end
