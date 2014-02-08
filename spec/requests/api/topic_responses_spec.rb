require 'spec_helper'

describe "GET /responses" do
	it "retrieves all responses from topic" do

		topic = Topic.create(title: "Title1", description: "description1")
		response = Topic::Response.create(content: "content1")
		response.topic_id = topic.id
		response.save

		get api_topic_responses_url(topic)

	  expect(response).to be_success
	end
end