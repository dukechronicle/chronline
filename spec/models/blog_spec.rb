require 'spec_helper'


describe Blog do

  subject { Blog.find('pokedex') }

  # Attributes for 'pokedex' blog are in config/settings/test.yml
  its(:id) { should == 'pokedex' }
  its(:name) { should == 'The Pokedex' }

  # Required to comply with ActiveModel interface
  it { should be_persisted }

end
