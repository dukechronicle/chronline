Fabricator(:article) do
  title { Faker::Lorem.words(5).join(' ') }
  subtitle "Oak arrives just in time"
  teaser "Ash becomes new Pokemon Champion."
  body "Pikachu wrecks everyone. The End."
  section "/news/university"
  authors(count: 1, fabricator: :staff)
end
