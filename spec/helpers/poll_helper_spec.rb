require 'spec_helper'

describe Site::PollHelper do
  let (:poll) { FactoryGirl.create(:poll) }
  let (:poll_subsection) { FactoryGirl.create(:poll, section: '/news/university/') }

  describe "#find_section_poll" do
    context "when finding a poll for a subsection" do
      subject { helper.find_section_poll(Taxonomy.new(:sections, '/news/university/')) }

      its(:id) { should eq(poll_subsection.id) }
    end

    context "when finding a poll for a root section" do
      subject { helper.find_section_poll(Taxonomy.new(:sections, '/news/')) }

      its(:id) { should eq(poll.id) }
    end
  end
end
