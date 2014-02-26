class AddPreviewAndArticleToTeam < ActiveRecord::Migration
  def change
    add_column :tournament_teams, :preview, :text
    add_column :tournament_teams, :article_id, :integer
  end
end
