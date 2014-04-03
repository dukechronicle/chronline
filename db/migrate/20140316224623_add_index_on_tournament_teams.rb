class AddIndexOnTournamentTeams < ActiveRecord::Migration
  def change
    add_index :tournament_teams, :tournament_id
  end
end
