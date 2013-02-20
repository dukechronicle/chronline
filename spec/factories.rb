include ActionDispatch::TestProcess


FactoryGirl.define do
  factory :article do
    title { Faker::Lorem.words(5).join(' ') }
    subtitle "Oak arrives just in time"
    teaser "Ash becomes new Pokemon Champion."
    body "**Pikachu** wrecks everyone. The End."
    section "/news/university"
    authors { [Staff.find_or_create_by_name(Faker::Name.name)] }
  end

  factory :staff do
    name { Faker::Name.name }
    affiliation "PokeTrainer"
    tagline "Wanna be the very best"
    twitter "pokefan"
    columnist false
    biography "The best Pokemon trainer ever."
  end

  factory :image do
    attribution "? / Gym Leader"
    caption "Ash battles Gary to become the Pokemon champion."
    location "Pokemon Stadium"
    photographer { Staff.find_or_create_by_name(Faker::Name.name) }
    original { fixture_file_upload('lib/sample-images/pikachu.png') }
  end
end
