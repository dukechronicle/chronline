require 'spec_helper'


describe ArticleHelper do

  describe "#disqus_options" do
    let(:article) { FactoryGirl.create(:article) }
    subject { ActiveSupport::JSON.decode(helper.disqus_options(article)) }

    it "should be valid JSON" do
      lambda { subject }.should_not raise_error(MultiJson::DecodeError)
    end

    it "should have disqus options fields" do
      should have_key('production')
      should have_key('shortname')
      should have_key('identifier')
      should have_key('title')
      should have_key('url')
    end
  end

end
