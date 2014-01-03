class CreateTopicResponses < ActiveRecord::Migration
  def change
    create_table :topic_responses do |t|
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
