require 'spec_helper'


describe "custom matchers" do

  describe "include_in_order" do
    subject { [1, 2, 3, 4] }

    it { should include_in_order(1) }
    it { should include_in_order(1, 2) }
    it { should include_in_order(1, 2, 4) }

    it { should_not include_in_order(5) }
    it { should_not include_in_order(1, 5) }
    it { should_not include_in_order(4, 2) }
  end

end
