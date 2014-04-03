namespace :tournaments do

  desc "Send an email all users with incomplete brackets"
  task notify_incomplete: :environment do
    Tournament.where('start_date > ?', DateTime.now).find_each do |tournament|
      tournament.brackets.includes(:user).find_each do |bracket|
        unless bracket.complete?
          TournamentBracketMailer.notify_incomplete(bracket).deliver
        end
      end
    end
  end

end
