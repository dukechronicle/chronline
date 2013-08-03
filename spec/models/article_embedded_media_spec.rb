require 'spec_helper'

describe Article::EmbeddedMedia do
  before do
    @article = FactoryGirl.create(:article)
    @image = FactoryGirl.create(:image)
  end

  describe "#render_images" do
    before { @article.body = "{{Image:#{@image.id}}}" }
    subject { Article::EmbeddedMedia.new(@article.body) }

    it "should render the tag into html" do
      html = "<img src=\"#{@image.original.url(:thumb_rect)}\" />"
      subject.to_s.should == html
    end
  end
end
