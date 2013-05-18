Fabricator(:staff) do
  name { Faker::Name.name }
  affiliation "PokeTrainer"
  tagline "Wanna be the very best"
  twitter "pokefan"
  columnist false
  biography "The best Pokemon trainer ever."
end
