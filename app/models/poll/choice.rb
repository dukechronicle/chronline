class Poll::Choice < ActiveRecord::Base
  attr_accessible :poll_id, :title, :votes

  belongs_to :poll

  validates :title, presence: true

  default_value_for(:votes) { 0 }

  default_scope order: 'votes DESC, title ASC'

  def self.find_create_or_delete_poll_choices(poll, titles)
    unused_choices = poll.choices.reject { |choice| not titles.include? choice.title }
    unused_choices.each(&:destroy)

    found_choices = {}
    poll.choices.where(title: titles).each do |choice|
      found_choices[choice.title] = choice
    end
    titles.each do |title|
      self.transaction do
        if not found_choices.has_key?(title)
          found_choices[title] = Poll::Choice.create!(title: title)
        end
      end
    end
    found_choices.values
  end
end
