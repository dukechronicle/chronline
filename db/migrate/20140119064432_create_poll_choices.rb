class CreatePollChoices < ActiveRecord::Migration
  def change
    create_table :poll_choices do |t|
      t.integer :poll_id
      t.string :title
      t.integer :votes

      t.timestamps
    end
  end
end
