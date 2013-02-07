require 'spec_helper'


describe Disqus do
  API_KEY = "Ditto"

  let(:disqus) { Disqus.new(API_KEY) }

  describe "#request" do

    before do
      ActiveResource::HttpMock.respond_to do |mock|
        @stub = stub_request(:get, "https://disqus.com/api/3.0/pokemon/" +
                            "fireTypes.json?api_key=#{API_KEY}&name=charmander")
          .to_return(body: '{"evolution": "charmeleon"}', status: 200)
        @response = disqus.request(:pokemon, :fire_types, name: :charmander)
      end
    end

    it "should make a request to Disqus API" do
      @stub.should have_been_requested
    end

    it "should return parsed body" do
      @response.should == {"evolution" => "charmeleon"}
    end

  end

end
