require 'spec_helper'


describe Disqus do
  API_KEY = "Ditto"

  let(:disqus) { Disqus.new(API_KEY) }

  describe "#request" do

    context "successful response" do
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

    context "unsuccessful response" do

      it "should return nil" do
        stub_request(:get, "https://disqus.com/api/3.0/pokemon/" +
                     "fireTypes.json?api_key=#{API_KEY}&name=charmander")
          .to_return(status: 500)
        disqus.request(:pokemon, :fire_types, name: :charmander)
          .should be_nil
      end

    end

  end

end
