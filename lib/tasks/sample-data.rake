namespace :db do

  desc "Refresh the database"
  task :run => [:drop, :migrate, :populate]

  desc "Fill database with sample data"
  task populate: :environment do
    (15 - Author.count).times do
      Author.create!(name: Faker::Name.name)
    end
    (5 - Photographer.count).times do
      Photographer.create!(name: Faker::Name.name)
    end
    authors = Author.select(15)
    photographers = Photographer.select(5)

    if Image.any?
      image = Image.all.sample
    else
      image = Image.new(original: File.new('lib/sample-images/pikachu.png'),
        caption: Faker::HipsterIpsum.sentence)
      image.photographer = photographers.sample
      image.save!
    end

    30.times do |n|
      title = Faker::HipsterIpsum.words(5).map(&:capitalize).join(' ')
      subtitle = Faker::HipsterIpsum.words(5).map(&:capitalize).join(' ')
      article = Article.new(title: title,
                            subtitle: subtitle,
                            teaser: Faker::HipsterIpsum.sentence,
                            body: Faker::HipsterIpsum.paragraph,
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
