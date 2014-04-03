class TournamentBracketMailer < ActionMailer::Base
  def notify_incomplete(bracket)
    @bracket = bracket
    @start_time = @bracket.tournament.start_date
      .in_time_zone("Eastern Time (US & Canada)")
    mail(to: @bracket.user.email, subject: 'Complete your bracket')
  end
end
