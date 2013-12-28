def random_taxonomy
  Taxonomy.levels.flatten.sample
end

if User.find_by_email("admin@chron.dev").nil?
  User.create!(
    email: "admin@chron.dev",
    first_name: "Super",
    last_name: "User",
    password: "password",
    password_confirmation: "password",
  )
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
    title: Faker::SamuelJackson.words(5).map(&:capitalize).join(' '),
    subtitle: Faker::SamuelJackson.words(5).map(&:capitalize).join(' '),
    teaser: Faker::SamuelJackson.sentence,
    body: Faker::SamuelJackson.paragraphs(2).join("\n"),
    section: random_taxonomy,
    image_id: image.id,
    published_at: (1..365).to_a.sample.days.ago,
    author_ids: [staff.sample.id],
  )
end

30.times do |n|
  blog_post = Blog::Post.create!(
    title: Faker::SamuelJackson.words(5).map(&:capitalize).join(' '),
    body: Faker::SamuelJackson.paragraphs(4).join("\n"),
    blog: Blog.all.sample,
    image_id: image.id,
    author_ids: [staff.sample.id],
    published_at: (1..365).to_a.sample.days.ago,
  )
end
