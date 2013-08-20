require 'spec_helper'


describe Searchable do
  subject { searchable_class }

  let(:searchable_class) do
    Class.new do
      include Searchable
    end
  end

  describe "accessors" do
    subject { searchable_class.new }

    it { should respond_to(:matched_title) }
    it { should respond_to(:matched_title=) }
    it { should respond_to(:matched_content) }
    it { should respond_to(:matched_content=) }
  end

  its(:search_facets) { should == [] }

  describe "::search_facet" do
    subject { searchable_class.search_facets }

    context "when called with just an id" do
      before { searchable_class.search_facet :trainer }
      it "should have default label and decorator" do
        should == [[:trainer, 'Trainer', Searchable::FacetDecorator]]
      end
    end

    context "when called with just an id" do
      before { searchable_class.search_facet :trainer_id }
      it "should have default label and decorator" do
        should == [[:trainer_id, 'Trainer', Searchable::FacetDecorator]]
      end
    end

    context "when called with a label" do
      before { searchable_class.search_facet :trainer, label: 'PokeTrainer' }
      it "should have the label" do
        should == [[:trainer, 'PokeTrainer', Searchable::FacetDecorator]]
      end
    end

    context "when called with a decorator" do
      let(:decorator) { double('TestFacetDecorator') }
      before { searchable_class.search_facet :trainer, decorator: decorator }
      it "should have the decorator" do
        should == [[:trainer, 'Trainer', decorator]]
      end
    end

    context "when called with a model" do
      before { searchable_class.search_facet :trainer, model: Staff }
      it "should have an association decorator for the model" do
        facet = searchable_class.search_facets.first
        decorator = facet[2]
        # be_a_kind_of doesn't work for anonymous classes
        decorator.superclass.should == Searchable::AssociationFacetDecorator
        decorator.send(:model).should == Staff
        decorator.send(:model_method).should == :name
      end
    end
  end

end
