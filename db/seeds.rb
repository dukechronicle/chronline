def random_taxonomy(taxonomy)
  Taxonomy.levels(taxonomy).flatten.sample
end

def body_html
  Faker::Lorem.paragraphs(4).map do |paragraph|
    "<p>#{paragraph}</p>"
  end.join
end

if User.find_by_email("admin@chron.dev").nil?
  user = User.new(
    email: "admin@chron.dev",
    first_name: "Super",
    last_name: "User",
    password: "password",
    password_confirmation: "password",
  )
  user.role = :admin
  user.save!
end

staff = 15.times.map do |n|
  Staff.create!(name: Faker::Name.name)
end

image = Image.create!(
  original: File.new(Rails.root.join('lib', 'sample-images', 'pikachu.png')),
  caption: Faker::Lorem.sentence,
  photographer_id: staff.sample.id,
)

30.times do |n|
  article = Article.create!(
    title: Faker::Lorem.words(5).map(&:capitalize).join(' '),
    subtitle: Faker::Lorem.words(5).map(&:capitalize).join(' '),
    teaser: Faker::Lorem.sentence,
    body: body_html,
    section: random_taxonomy(:sections),
    image_id: image.id,
    published_at: (1..365).to_a.sample.days.ago,
    author_ids: [staff.sample.id],
  )
end

30.times do |n|
  blog_post = Blog::Post.create!(
    title: Faker::Lorem.words(5).map(&:capitalize).join(' '),
    body: body_html,
    section: random_taxonomy(:blogs),
    image_id: image.id,
    author_ids: [staff.sample.id],
    published_at: (1..365).to_a.sample.days.ago,
  )
end

tournament = Tournament.create!(
  name: "NCAA",
  event: "Men's Basketball",
  start_date: Date.new(2013, 3, 1),
  region0: 'South',
  region1: 'East',
  region2: 'Midwest',
  region3: 'West',
)
teams = YAML.load_file(
  Rails.root.join('db', 'fixtures', 'tournament_teams.yml'))
teams.each { |team| tournament.teams.create!(team) }

0.upto(62) do |position|
  game = tournament.games.build(
    position: position,
    start_time: Date.new(2013, 3, 1 + rand(30))
  )
  game.update_teams
  game.save!
end
