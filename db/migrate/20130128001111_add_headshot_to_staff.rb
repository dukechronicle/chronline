class AddHeadshotToStaff < ActiveRecord::Migration
  def change
    add_column :staff, :headshot_id, :integer
  end
end
