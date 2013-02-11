namespace :db do

  desc "Refresh the database"
  task :refresh => [:reset, :populate, 'sunspot:solr:reindex']

  desc "Fill database with sample data"
  task populate: :environment do

    # TODO create relevant config variables in development YAML
    unless User.find_by_email("admin@chron.dev")
      User.create!(
          email: "admin@chron.dev",
          first_name: "Super",
          last_name: "User",
          password: "password",
          password_confirmation: "password"
        )
    end

    staff = 15.times.map do |n|
      Staff.create!(name: Faker::Name.name)
    end

    image = Image.new(original: File.new('lib/sample-images/pikachu.png'),
                      caption: Faker::Lorem.sentence)
    image.photographer = staff.sample
    image.save!

    30.times do |n|
      title = Faker::SamuelJackson.words(5).map(&:capitalize).join(' ')
      subtitle = Faker::SamuelJackson.words(5).map(&:capitalize).join(' ')
      article = Article.new(title: title,
                            subtitle: subtitle,
                            teaser: Faker::SamuelJackson.sentence,
                            body: Faker::SamuelJackson.paragraphs(2),
                            section: random_taxonomy,
                            image_id: image.id)
      article.authors = [staff.sample]
      article.save!
    end
  end
end

def random_taxonomy
  Taxonomy.levels.flatten.sample
end
