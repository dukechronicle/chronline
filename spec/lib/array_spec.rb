require 'array'


describe Array do

  describe "#to_h" do
    before { @array = [[:a, 1], ['b', [2]]] }

    it { @array.to_h.should == {a: 1, 'b' => [2]} }
  end

end
