class AddScoreToTournamentBrackets < ActiveRecord::Migration
  def change
    add_column :tournament_brackets, :score, :integer, default: 0
    add_index :tournament_brackets, :score
  end
end
