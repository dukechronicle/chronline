class IncreaseCaptionSize < ActiveRecord::Migration
  def change
    change_column :images, :caption, :string, limit: 500
  end
end
