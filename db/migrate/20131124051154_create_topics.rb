class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
    	t.string		:title
    	t.text			:description
    	t.boolean 	:archived, default: false

      t.timestamps
    end
  end
end
