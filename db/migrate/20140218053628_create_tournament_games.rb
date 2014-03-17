class CreateTournamentGames < ActiveRecord::Migration
  def change
    create_table :tournament_games do |t|
      t.integer :tournament_id
      t.integer :team1_id
      t.integer :team2_id
      t.integer :score1
      t.integer :score2
      t.integer :position
      t.datetime :start_time
      t.boolean :final, default: false

      t.timestamps
    end

    add_index :tournament_games, [:tournament_id, :position], unique: true
  end
end
