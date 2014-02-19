class CreateTournamentBrackets < ActiveRecord::Migration
  def change
    create_table :tournament_brackets do |t|
      t.integer :tournament_id
      t.integer :user_id
      t.text :picks

      t.timestamps
    end

    add_index :tournament_brackets, [:tournament_id, :user_id], unique: true
  end
end
