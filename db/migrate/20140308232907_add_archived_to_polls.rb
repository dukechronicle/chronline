class AddArchivedToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :archived, :boolean, default: false
  end
end
