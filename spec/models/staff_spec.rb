require 'spec_helper'

describe Staff do
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
