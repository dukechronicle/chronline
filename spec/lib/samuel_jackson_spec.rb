require 'spec_helper'

describe Faker::SamuelJackson do
  it "should generate random words" do
    Faker::SamuelJackson.word.should match(/1\+|[ a-z]+/i)
    Faker::SamuelJackson.words.join(' ' ).should match(/1\+|[ a-z]+/i)
  end

  it "should generate random sentences" do
    Faker::SamuelJackson.sentence.should match(/1\+|[ a-z]+/i)
    Faker::SamuelJackson.sentences.join(' ').should match(/1\+|[ a-z]+/i)
  end

  it "should generate random paragraphs" do
    Faker::SamuelJackson.paragraph.should match(/1\+|[ a-z]+/i)
    Faker::SamuelJackson.paragraphs.join(' ').should match(/1\+|[ a-z]+/i)
  end
end
