class CreateTopicResponses < ActiveRecord::Migration
  def change
    create_table :topic_responses do |t|
    	t.integer     :topic_id
			t.boolean			:approved, default: false
			t.boolean			:reported, default: false
			t.integer			:upvotes, default: 0
			t.integer 		:downvotes, default: 0
			t.string 			:content
      t.float       :score

      t.timestamps
    end

  end
end
