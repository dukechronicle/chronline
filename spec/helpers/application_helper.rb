require 'spec_helper'


describe ApplicationHelper do

  describe "#datetime_tag" do
    let(:date) { DateTime.new(1999, 10, 1) }
    subject { helper.datetime_tag(date, "pewter", class: "vermillion") }

    it "should create a time HTML tag" do
      should == '<time class="vermillion" data-format="pewter" datetime="1999-10-01T00:00:00+00:00"></time>'
    end
  end

end
