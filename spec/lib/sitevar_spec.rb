require 'spec_helper'

describe Sitevar do
  before(:all) do
    # In development and production, this is run in config/initializers/redis.rb
    Sitevar.config.redis = $redis
  end

  describe "::new" do
    it { expect { Sitevar.new }.to raise_error(NoMethodError) }
  end

  describe "::[]" do
    context "when sitevar does not exist" do
      subject { Sitevar[:fake_sitevar] }
      it { should be_nil }
    end

    context "when sitevar does exist" do
      subject { Sitevar[:region] }

      it { should be_a(Sitevar) }

      it "should have the correct name, description, and type" do
        subject.name.should == 'region'
        subject.label.should == 'Region'
        subject.description.should == 'The current region of the Pokemon world.'
        subject.type.should == 'string'
      end
    end
  end

  describe "::each" do
    it "should yield each sitevar" do
      sitevars = Sitevar.each
      sitevars.size.should == 1
      sitevars.peek.should be_a(Sitevar)
      sitevars.peek.name.should == 'region'
    end
  end

  describe "::config" do
    subject { Sitevar.config }

    it "should store configuration variables" do
      subject.redis.should == $redis
      subject.key.should == Sitevar::Configuration::DEFAULT_KEY
    end

    it "should store sitevars with indifferent access" do
      subject.sitevars.should include('region')
      subject.sitevars.should include(:region)
    end

    context "when configuration variables are changed" do
      before { subject.redis = 'redis' }
      after { subject.redis = $redis }

      it "should return updated value" do
        subject.redis.should == 'redis'
      end
    end
  end

  describe "#value" do
    let(:region) { 'Johto' }
    before { $redis.hset(Sitevar.config.key, 'region', region) }

    it "should be the current sitevar value" do
      Sitevar[:region].value.should == region
    end

    it "should be accessible as a class method" do
      Sitevar.region.should == region
    end
  end

  describe "#value=" do
    let(:region) { 'Johto' }
    before { $redis.hset(Sitevar.config.key, 'region', 'Kanto') }

    it "should be the current sitevar value" do
      Sitevar[:region].value = region
      $redis.hget(Sitevar.config.key, 'region').should == region
    end

    it "should be accessible as a class method" do
      Sitevar.region = region
      $redis.hget(Sitevar.config.key, 'region').should == region
    end
  end
end
