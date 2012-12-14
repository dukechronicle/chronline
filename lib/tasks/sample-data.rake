namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    authors = 15.times.map do |n|
      Author.create!(name: Faker::Name.name)
    end
    30.times do |n|
      title = Faker::Lorem.words(5).map(&:capitalize).join(' ')
      subtitle = Faker::Lorem.words(5).map(&:capitalize).join(' ')
      article = Article.new(title: title,
                            subtitle: subtitle,
                            teaser: Faker::Lorem.sentence,
                            body: Faker::Lorem.paragraph,
                            section: '/news/university')
      article.authors = [authors.sample]
      article.save!
    end
  end
end
