require 'spec_helper'

describe ChronSlug do
  describe "#normalize_friendly_id" do
    let(:record) do
      record = Object.new
      record.extend(ChronSlug)
      record
    end

    subject do
      record.normalize_friendly_id('Ash defeats Gary in Indigo Plateau')
    end

    it "should be lowercased" do
      should match(/[a-z_\d\-]+/)
    end

    it "should contain key words of title" do
      should include('ash')
      should include('defeats')
      should include('gary')
      should include('indigo')
      should include('plateau')
    end

    it "should not have unnecessary words" do
      should_not include('-in-')
    end

    context "with long title" do
      subject { record.normalize_friendly_id('a' * 49 + '-' + 'b' * 50, 50) }

      it "should have a limit on the number of characters" do
        should have_at_most(50).characters
      end

      it "should not end with a dash" do
        should_not match(/\-$/)
      end
    end
  end
end
