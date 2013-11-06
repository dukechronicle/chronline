class ChangePidToGidInGalleries < ActiveRecord::Migration
  def up
    rename_column :galleries, :pid, :gid
  end

  def down
    rename_column :galleries, :gid, :pid
  end
end
