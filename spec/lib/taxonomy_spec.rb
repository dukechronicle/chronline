require 'spec_helper'


describe Taxonomy do

  subject { Taxonomy.new(['news', 'university']) }

  context "when constructed with a string taxonomy" do
    subject { Taxonomy.new('/news/univerSITY/') }

    it "should normalize the taxonomy" do
      subject.to_a.should == ['News', 'University']
    end
  end

  context "when constructed with an invalid taxonomy" do
    it "should raise an InvalidTaxonomyError" do
      constructor = lambda { Taxonomy.new(['fake', 'taxonomy']) }
      constructor.should raise_error(Taxonomy::InvalidTaxonomyError)
    end
  end

  context "when constructed with no taxonomy" do
    it { Taxonomy.new.to_a.should == [] }
  end

  context "when constructed with nil argument" do
    it { Taxonomy.new.to_a.should == [] }
  end

  context "when constructed with root string" do
    it { Taxonomy.new('/').to_a.should == [] }
  end

  describe "#to_s" do
    it { subject.to_s.should == '/news/university/' }
  end

  describe "#to_a" do
    it { subject.to_a.should == ['News', 'University'] }
  end

  describe "#name" do
    its(:name) { should == 'University' }
  end

  describe "#to_json" do
    it "should encode the taxonomy array as JSON" do
      subject.to_json.should == ['News', 'University'].to_json
    end
  end

  describe "#==" do
    it { should == Taxonomy.new(['News', 'University']) }
    it { should_not == Taxonomy.new(['News']) }
    it { should_not == Taxonomy.new(['News', 'University', 'Academics']) }
    it { should_not == ['News', 'University'] }
  end

  describe "comparators" do
    let(:parent) { Taxonomy.new(['News']) }
    let(:child)  { Taxonomy.new(['News', 'University', 'Academics']) }
    let(:other)  { Taxonomy.new(['Sports']) }

    describe "#<" do
      it { should be < parent }
      it { should_not be < subject }
      it { should_not be < child }
      it { should_not be < other }
    end

    describe "#<=" do
      it { should be <= parent }
      it { should be <= subject }
      it { should_not be <= child }
      it { should_not be <= other }
    end

    describe "#<" do
      it { should_not be > parent }
      it { should_not be > subject }
      it { should be > child }
      it { should_not be > other }
    end

    describe "#<=" do
      it { should_not be >= parent }
      it { should be >= subject }
      it { should be >= child }
      it { should_not be >= other }
    end
  end

  describe "#root?" do
    it { Taxonomy.new.root?.should be_true }
    it { subject.root?.should be_false }
  end

  describe "#[]" do
    it { subject[0].should == 'News' }
    it { subject[1].should == 'University' }
    it { subject[2].should == nil }
  end

  describe "#children" do
    it "should return child Taxonomy objects" do
      sections = ['Academics', 'Board of Trustees']
      children = sections.map do |section|
        Taxonomy.new(['News', 'University'] << section)
      end
      subject.children.should == children
    end
  end

  describe "#parent" do
    its(:parent) { should == Taxonomy.new(['News']) }
    it { Taxonomy.new.parent.should be_nil }
  end

  describe "#parents" do
    its(:parents) do
      should == [Taxonomy.new(['News']),
                 Taxonomy.new(['News', 'University'])]
    end
  end

  describe "::main_sections" do
    it "should return top level Taxonomy objects" do
      sections = ['News', 'Sports', 'Opinion', 'Recess', 'Towerview']
      taxonomies = sections.map {|section| Taxonomy.new([section])}
      Taxonomy.main_sections.should == taxonomies
    end
  end

  describe "::levels" do
    it "should return each level of the taxonomy tree as arrays" do
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
