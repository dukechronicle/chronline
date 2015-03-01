include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :article do
    title { Faker::Lorem.words(5).join(' ') }
    subtitle "Oak arrives just in time"
    teaser "Ash becomes new Pokemon Champion."
    body "**Pikachu** wrecks everyone. The End."
    section ['News', 'University']
    authors { [ FactoryGirl.create(:staff) ] }
    published_at DateTime.new(2008, 9, 30)
  end

  factory :staff do
    name { Faker::Name.name }
    affiliation "PokeTrainer"
    tagline "Wanna be the very best"
    twitter "pokefan"
    columnist false
    biography "The best Pokemon trainer ever."

    factory :photographer do
      after(:create) do |staff|
        FactoryGirl.create(:image, photographer: staff)
      end
    end
  end

  factory :image do
    attribution "? / Gym Leader"
    caption "Ash battles Gary to become the Pokemon champion."
    location "Pokemon Stadium"
    association :photographer, factory: :staff, strategy: :build
    original { fixture_file_upload('lib/sample-images/pikachu.png') }
  end

  factory :blog_post, class: Blog::Post do
    title "Ash Catches a Pokemon"
    body "It was a Caterpie."
    blog { Blog.find('pokedex') }
    authors { [ FactoryGirl.create(:staff) ] }
    published_at Date.new(2008, 9, 30)
  end

  factory :user do
    first_name "Trainer"
    last_name "Misty"
    email "misty@cerulean.city"
    password "starmie"

    factory :admin do
      first_name "Ash"
      last_name "Ketchum"
      email "ash@ketch.um"
      password "charizard"
      role "admin"
    end
  end

  factory :blog_series, class: Blog::Series do
    association :image, factory: :image, strategy: :build
    tag { ActsAsTaggableOn::Tag.find_or_create_with_like_by_name("Route 14") }
    blog { Blog.find('pokedex') }
  end

  factory :tournament do
    name 'NCAA'
    event "Men's Basketball"
    start_date Date.new(2013, 3, 1)
    region0 'South'
    region1 'East'
    region2 'Midwest'
    region3 'West'
  end

  factory :game, class: Tournament::Game do
    start_time Date.new(2013, 3, 1)
    tournament
  end

  factory :poll, class: Poll do
    title 'What is the best Pokemon?'
    description 'Which one of these is the best Pokemon, objectively?'
    section ['News']
    archived false
  end
end
