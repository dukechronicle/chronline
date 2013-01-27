class StaffRemoveType < ActiveRecord::Migration
  def change
    remove_column :staff, :type
  end
end
