namespace :db do

  desc "Refresh the database"
  task :refresh => [:reset, :populate]

  desc "Fill database with sample data"
  task populate: :environment do
    authors = 15.times.map do |n|
      Author.create!(name: Faker::Name.name)
    end

    photographers = 5.times.map do |n|
      Photographer.create!(name: Faker::Name.name)
    end

    image = Image.new(original: File.new('lib/sample-images/pikachu.png'),
                      caption: Faker::Lorem.sentence)
    image.photographer = photographers.sample
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
      article.authors = [authors.sample]
      article.save!
    end
  end
end

def random_taxonomy
  Taxonomy.levels.flatten.sample
end
