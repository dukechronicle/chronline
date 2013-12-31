require 'spec_helper'


describe PostHelper do
  let(:post) { FactoryGirl.create(:article) }

  describe "#display_date" do
    before do
      post.created_at = Date.new(2013, 1, 1)
      helper.stub(:datetime_tag)
    end

    it "should display creation date in specified format" do
      helper.display_date(post, '%Y')
      helper.should have_received(:datetime_tag)
        .with(post.published_at, '%Y', timestamp: false)
    end

    it "should default to readable date format" do
      helper.display_date(post)
      helper.should have_received(:datetime_tag)
        .with(post.published_at, 'mmmm d, yyyy', timestamp: false)
    end
  end

  describe "#disqus_options" do
    subject { ActiveSupport::JSON.decode(helper.disqus_options(post)) }

    it "should be valid JSON" do
      expect { subject }.not_to raise_error
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
