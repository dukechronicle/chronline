require 'spec_helper'

require 'exceptions'
require 'taxonomy'


describe Taxonomy do

  before { @taxonomy = Taxonomy.new(['news', 'university']) }

  describe "when constructed with a string taxonomy" do
    before { @taxonomy = Taxonomy.new('news/univerSITY/') }

    it "should normalize the taxonomy" do
      @taxonomy.to_a.should == ['News', 'University']
    end
  end

  describe "when constructed with an invalid taxonomy" do
    it "should raise an Exception::InvalidTaxonomy" do
      constructor = lambda { Taxonomy.new(['fake', 'taxonomy']) }
      constructor.should raise_error(Exceptions::InvalidTaxonomyError)
    end
  end

  describe "#to_s()" do
    it { @taxonomy.to_s.should == 'news/university/' }
  end

  describe "#to_a()" do
    it { @taxonomy.to_a.should == ['News', 'University'] }
  end

end
