require 'spec_helper'


describe Array do

  describe "#to_h" do
    subject { [[:a, 1], ['b', [2]]] }

    it { subject.to_h.should == {a: 1, 'b' => [2]} }
  end

end
