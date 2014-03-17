require 'spec_helper'

describe Tournament::Game do
  describe "#round" do
    it "should be round 1 for games 0-32" do
      game = FactoryGirl.create(:game, position: 0)
      game.round.should == 1
      game = FactoryGirl.create(:game, position: 31)
      game.round.should == 1
    end

    it "should be round 2 for games 32-47" do
      game = FactoryGirl.create(:game, position: 32)
      game.round.should == 2
      game = FactoryGirl.create(:game, position: 47)
      game.round.should == 2
    end

    it "should be round 3 for games 48-55" do
      game = FactoryGirl.create(:game, position: 48)
      game.round.should == 3
      game = FactoryGirl.create(:game, position: 55)
      game.round.should == 3
    end

    it "should be round 4 for games 56-59" do
      game = FactoryGirl.create(:game, position: 56)
      game.round.should == 4
      game = FactoryGirl.create(:game, position: 59)
      game.round.should == 4
    end

    it "should be round 5 for games 60-61" do
      game = FactoryGirl.create(:game, position: 60)
      game.round.should == 5
      game = FactoryGirl.create(:game, position: 61)
      game.round.should == 5
    end

    it "should be round 6 for game 62" do
      game = FactoryGirl.create(:game, position: 60)
      game.round.should == 5
      game = FactoryGirl.create(:game, position: 61)
      game.round.should == 5
    end
  end
end
