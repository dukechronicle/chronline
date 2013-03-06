require 'spec_helper'

Blog::Data['pokedex'] = {
  'name' => 'The Pokedex'
}


describe Blog do

  it "should not be directly instantiable" do
    ->{Blog.new}.should raise_error
  end

  subject { Blog.find('pokedex') }

  # Attributes for 'pokedex' blog are in config/settings/test.yml
  its(:id) { should == 'pokedex' }
  its(:name) { should == 'The Pokedex' }

  # Required to comply with ActiveModel interface
  it { should be_persisted }

  it { subject.to_param.should == 'pokedex' }

end
