require 'spec_helper'

require 'exceptions'
require 'taxonomy'


describe Taxonomy do

  before { @taxonomy = Taxonomy.new(['news', 'university']) }

  subject { @taxonomy }

  describe "when constructed with a string taxonomy" do
    before { @taxonomy = Taxonomy.new('/news/univerSITY/') }

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

  describe "when constructed with no taxonomy" do
    it { Taxonomy.new.to_a.should == [] }
  end

  describe "#to_s" do
    it { @taxonomy.to_s.should == '/news/university/' }
  end

  describe "#to_a" do
    it { @taxonomy.to_a.should == ['News', 'University'] }
  end

  describe "#name" do
    it { @taxonomy.name.should == 'University' }
  end

  describe "#==" do
    it { @taxonomy.should == Taxonomy.new(['News', 'University']) }
    it { @taxonomy.should_not == Taxonomy.new(['News']) }

    it do
      @taxonomy.should_not == Taxonomy.new(['News', 'University', 'Academics'])
    end

    it { @taxonomy.should_not == ['News', 'University'] }
  end

  describe "#children" do
     it do
      sections = ['Academics', 'Board of Trustees']
      children = sections.map do |section|
        Taxonomy.new(['News', 'University'] + [section])
      end
      @taxonomy.children.should == children
    end
  end

  describe "#parent" do
    it { @taxonomy.parent.should == Taxonomy.new(['News']) }
    it { Taxonomy.new.parent.should be_nil }
  end

  describe "::main_sections" do
    it do
      sections = ['News', 'Sports', 'Opinion', 'Recess', 'Towerview']
      taxonomies = sections.map {|section| Taxonomy.new([section])}
      Taxonomy.main_sections.should == taxonomies
    end
  end
end
