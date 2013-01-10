# == Schema Information
#
# Table name: staff
#
#  id          :integer          not null, primary key
#  affiliation :string(255)
#  biography   :text
#  columnist   :boolean
#  name        :string(255)
#  tagline     :string(255)
#  twitter     :string(255)
#  type        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string(255)
#

require 'spec_helper'

describe Staff do
  describe Staff do
    before do
      @staff = [Author.create(name: 'Joe Smith'),
                Author.create(name: 'John Smith'),
                Photographer.create(name: 'Jordan Smith'),
                Author.create(name: 'Will Smith')]
    end

    describe "::search" do
      it "should return staff with matching names" do
        Staff.search('Jo').should have(3).members
      end

      it "should return all when given nil" do
        Staff.search(nil).should have(4).members
      end

      it "should search by staff type" do
        Photographer.search(nil).should have(1).members
      end
    end
  end

  describe Author do
    describe "::find_or_create_all_by_name" do
      before(:each) do
        @author = Author.create(name: 'Ash Ketchum')
      end

      it "should return authors if they exist" do
        authors = Author.find_or_create_all_by_name(['Ash Ketchum'])
        authors.should == [@author]
      end

      it "should create authors if they don't exist" do
        expect { Author.find_or_create_all_by_name(['Hiker Martin']) }
          .to change(Author, :count).by(1)
      end

      it "should return new authors when they don't exist" do
        Author.find_or_create_all_by_name(['Ash Ketchum', 'Hiker Martin'])
          .should == [@author, Author.find_by_name('Hiker Martin')]
      end
    end
  end
end
