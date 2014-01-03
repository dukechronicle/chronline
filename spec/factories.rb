include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :article do
    title { Faker::Lorem.words(5).join(' ') }
    subtitle "Oak arrives just in time"
    teaser "Ash becomes new Pokemon Champion."
    body "**Pikachu** wrecks everyone. The End."
    section ['News', 'University']
    authors { [ FactoryGirl.create(:staff) ] }
    published_at Date.new(2008, 9, 30)
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
    first_name "Ash"
    last_name "Ketchum"
    email "ash@ketch.um"
    password "charizard"
  end
end
