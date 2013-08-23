require 'spec_helper'

MOCK_TAXONOMY = <<EOS
---
- id: 1
  name: News
  children:
    - id: 2
      name: University
      children:
        - id: 3
          name: Academics
        - id: 4
          name: Merged
          new_id: 3
- id: 5
  name: Sports
EOS
Taxonomy.const_set('Tree', YAML.load(MOCK_TAXONOMY))

describe "/sections/*" do
  describe "GET /sections" do
    before { get api_sections_url(subdomain: :api) }
    let(:nodes) { ActiveSupport::JSON.decode(response.body) }
    subject { nodes }

    it { should have(5).nodes }

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
