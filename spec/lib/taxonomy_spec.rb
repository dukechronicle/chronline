require 'spec_helper'

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
    it "should raise an InvalidTaxonomyError" do
      constructor = lambda { Taxonomy.new(['fake', 'taxonomy']) }
      constructor.should raise_error(Taxonomy::InvalidTaxonomyError)
    end
  end

  describe "when constructed with no taxonomy" do
    it { Taxonomy.new.to_a.should == [] }
  end

  describe "when constructed with nil argument" do
    it { Taxonomy.new.to_a.should == [] }
  end

  describe "when constructed with root string" do
    it { Taxonomy.new('/').to_a.should == [] }
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

  describe "#to_json" do
    it { @taxonomy.to_json.should == ['News', 'University'].to_json }
  end

  describe "#==" do
    it { @taxonomy.should == Taxonomy.new(['News', 'University']) }
    it { @taxonomy.should_not == Taxonomy.new(['News']) }

    it do
      @taxonomy.should_not == Taxonomy.new(['News', 'University', 'Academics'])
    end

    it { @taxonomy.should_not == ['News', 'University'] }
  end

  describe "#<" do
    it { @taxonomy.should be < Taxonomy.new(['News']) }
    it { @taxonomy.should_not be < Taxonomy.new(['News', 'University']) }
    it { @taxonomy.should_not be < Taxonomy.new(['News', 'University', 'Academics']) }
    it { @taxonomy.should_not be < Taxonomy.new(['Sports']) }
  end

  describe "#<=" do
    it { @taxonomy.should be <= Taxonomy.new(['News']) }
    it { @taxonomy.should be <= Taxonomy.new(['News', 'University']) }
    it { @taxonomy.should_not be <= Taxonomy.new(['News', 'University', 'Academics']) }
    it { @taxonomy.should_not be <= Taxonomy.new(['Sports']) }
  end

  describe "#root?" do
    it { Taxonomy.new.root?.should be_true }
    it { @taxonomy.root?.should_not be_true }
  end

  describe "#[]" do
    it do
      @taxonomy[0].should == 'News'
      @taxonomy[1].should == 'University'
    end

    it { @taxonomy[2].should == nil }
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

  describe "#parents" do
    it do
      @taxonomy.parents.should == [Taxonomy.new(['News']),
                                   Taxonomy.new(['News', 'University'])]
    end
  end

  describe "::main_sections" do
    it do
      sections = ['News', 'Sports', 'Opinion', 'Recess', 'Towerview']
      taxonomies = sections.map {|section| Taxonomy.new([section])}
      Taxonomy.main_sections.should == taxonomies
    end
  end

  describe "::levels" do
    it do
      levels =
        [
         ['/news/', '/sports/', '/opinion/', '/recess/', '/towerview/'],
         ['/news/university/'],
         ['/news/university/academics/', '/news/university/board of trustees/'],
        ]
      Taxonomy.levels.should == levels.map do |level|
        level.map {|taxonomy| Taxonomy.new(taxonomy)}
      end
    end
  end
end
