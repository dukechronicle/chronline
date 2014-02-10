require 'spec_helper'

describe "GET /responses" do

	context "working with responses" do

		before(:all) do	
			@topic = Topic.create(title: "Title1", description: "description1")
			@response1 = Topic::Response.create(content: "content1")
			@response1.topic_id = @topic.id
			@response1.save
			@response1_id = @response1.id
			@response2 = Topic::Response.create(content: "content1")
			@response2.topic_id = @topic.id
			@response2.save
			@response2_id = @response2.id
		end

		it "retrieves all responses from topic" do
			get api_topic_responses_url(@topic, subdomain: :api)
		  expect(response).to be_success
		end

		it "upvotes" do
			post upvote_api_topic_response_url(@topic, @response1, subdomain: :api)
			expect(response).to be_success
			expect(Topic::Response.find(@response1_id).upvotes).to eq(1)
		end
			
		it "downvotes" do
			post downvote_api_topic_response_url(@topic, @response1, subdomain: :api)
			expect(response).to be_success
			expect(Topic::Response.find(@response1_id).downvotes).to eq(1)
		end

		it "reports" do
			post report_api_topic_response_url(@topic, @response1, subdomain: :api)
			expect(response).to be_success
			expect(Topic::Response.find(@response1_id).reported).to be_true
		end

	end

end
