class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
    	t.integer     :topic_id
			t.boolean			:approved
			t.boolean			:reported
			t.integer			:upvotes
			t.integer 		:downvotes
			t.text 				:content

      t.timestamps
    end

  end
end
