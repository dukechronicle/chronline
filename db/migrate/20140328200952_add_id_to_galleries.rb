class AddIdToGalleries < ActiveRecord::Migration
  def change
    execute "ALTER TABLE galleries DROP PRIMARY KEY (gid);"
    add_column :galleries, :id, primary_key: false
    #execute "ALTER TABLE galleries ADD PRIMARY KEY (id);"
  end
end
