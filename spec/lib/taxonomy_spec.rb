require 'spec_helper'

describe Taxonomy do
  subject { Taxonomy.new(:sections, ['news', 'university']) }

  context "when constructed with a string taxonomy" do
    subject { Taxonomy.new(:sections, '/news/univerSITY/') }

    it "should normalize the taxonomy" do
      subject.path.should == ['News', 'University']
    end
  end

  context "when constructed with an unknown taxonomy" do
    it do
      expect { Taxonomy.new(:pikachu, ['News']) }
        .to raise_error(Taxonomy::UnknownTaxonomyError)
    end
  end

  context "when constructed with an invalid taxonomy term" do
    it do
      expect { Taxonomy.new(:sections, ['fake', 'taxonomy']) }
        .to raise_error(Taxonomy::InvalidTaxonomyError)
    end
  end

  context "when constructed with an inactive taxonomy term" do
    it do
      expect { Taxonomy.new(:sections, ['News', 'Merged']) }
        .to raise_error(Taxonomy::InvalidTaxonomyError)
    end
  end

  context "when constructed with no taxonomy" do
    it { Taxonomy.new(:sections).should be_root}
  end

  context "when constructed with nil argument" do
    it { Taxonomy.new(:sections, nil).should be_root }
  end

  context "when constructed with root string" do
    it { Taxonomy.new(:sections, '/').should be_root }
  end

  describe "#id" do
    it "should be a unique numeric id" do
      subject.id.should == 2
    end
  end

  its(:to_s) { should == '/news/university/' }
  its(:path) { should == ['News', 'University'] }
  its(:to_a) { should == ['News', 'University'] }
  its(:name) { should == 'University' }
  its(:to_json) { should == ['News', 'University'].to_json }

  describe "#==" do
    it { should == Taxonomy.new(:sections, ['News', 'University']) }
    it { should_not == Taxonomy.new(:sections, ['News']) }
    it { should_not == Taxonomy.new(:sections, ['News', 'University', 'Academics']) }
    it { should_not == ['News', 'University'] }
  end

  describe "comparators" do
    let(:parent) { Taxonomy.new(:sections, ['News']) }
    let(:child) { Taxonomy.new(:sections, ['News', 'University', 'Academics']) }
    let(:other) { Taxonomy.new(:sections, ['Sports']) }

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
    it { Taxonomy.new(:sections).root?.should be_true }
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
        Taxonomy.new(:sections, ['News', 'University'] << section)
      end
      subject.children.should == children
    end

    it "should not return inactive children" do
      section = Taxonomy.new(:sections, ['News'])
      section.children.should ==
        [Taxonomy.new(:sections, ['News', 'University'])]
    end
  end

  describe "#parent" do
    its(:parent) { should == Taxonomy.new(:sections, ['News']) }
    it "should be nil for the root taxonomy" do
      Taxonomy.new(:sections).parent.should be_nil
    end
  end

  its(:parents) do
    should == [
      Taxonomy.new(:sections, ['News']),
      Taxonomy.new(:sections, ['News', 'University'])
    ]
  end

  describe "::top_level" do
    subject { Taxonomy.top_level(:sections) }
    let(:sections) { ['News', 'Sports', 'Opinion', 'Recess', 'Towerview'] }

    it "should return top level Taxonomy objects" do
      should == sections.map { |section| Taxonomy.new(:sections, [section]) }
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
      Taxonomy.levels(:sections).should == levels.map do |level|
        level.map { |taxonomy| Taxonomy.new(:sections, taxonomy) }
      end
    end
  end

  describe "::nodes" do
    let(:nodes) { Taxonomy.nodes }
    subject { nodes }

    it { should have(9).nodes }

    describe "taxonomy nodes" do
      it 'should assign the "taxonomy" property to "sections"' do
        nodes.each do |node|
          node[:taxonomy].should == 'sections'
        end
      end

      it "should have a numeric id" do
        nodes.each do |node|
          node[:id].should be_an(Integer)
        end
      end

      it "should have the correct parent_id" do
        nodes.each do |node|
          node[:parent_id].should be_an(Integer) unless node[:parent_id].nil?
        end
      end

      it { nodes.each { |node| node.should have_key(:name) } }
    end
  end

end
