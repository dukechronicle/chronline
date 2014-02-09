require 'spec_helper'

describe "GET /responses" do
	it "retrieves all responses from topic" do

		topic = Topic.create(title: "Title1", description: "description1")
		response1 = Topic::Response.create(content: "content1")
		response1.topic_id = topic.id
		response1.save

		get api_topic_responses_url(topic, subdomain: :api)
	  expect(response).to be_success

	end
end

describe "POST /response" do

end
