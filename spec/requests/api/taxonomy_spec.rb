require 'spec_helper'

describe "/sections/*" do
  describe "GET /sections" do
    before { get api_sections_url(subdomain: :api) }
    let(:nodes) { ActiveSupport::JSON.decode(response.body) }
    subject { nodes }

    it { should have(12).nodes }
    it "should contain blog nodes" do
      nodes.map { |node| node['name'] }.should include('Pokedex')
    end

    it "should contain archived nodes" do
      nodes.map { |node| node['name'] }.should include('Archived')
    end

    describe "taxonomy node" do
      it 'should assign the "taxonomy" property to "sections"' do
        nodes.each do |node|
          node['taxonomy'].should == 'sections'
        end
      end

      it "should have a numeric id" do
        nodes.each do |node|
          node['id'].should be_an(Integer)
        end
      end

      it "should have the correct parent_id" do
        nodes.each do |node|
          node['parent_id'].should be_an(Integer) unless node['parent_id'].nil?
        end
      end

      it { nodes.each { |node| node.should have_key('name') } }
    end

  end
end
