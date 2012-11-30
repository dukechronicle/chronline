require 'spec_helper'

require 'taxonomy'


describe Taxonomy do

  before { @taxonomy = Taxonomy.new(['news', 'university']) }

  describe "when constructed with a string taxonomy" do
    before { @taxonomy = Taxonomy.new('news/univerSITY/') }

    it { @taxonomy.to_a.should == ['News', 'University'] }
  end

  describe "#to_s()" do
    it { @taxonomy.to_s.should == 'news/university/' }
  end

  describe "#to_a()" do
    it { @taxonomy.to_a.should == ['News', 'University'] }
  end

end
