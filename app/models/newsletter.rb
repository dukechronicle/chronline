class Newsletter
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :campaign_id, :scheduled_time, :test_email


  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value)
    end
    @gb = Gibbon::API.new(Settings.mailchimp.api_key)
  end

  def persisted?
    false
  end

  def create_campaign
    response = @gb.campaigns.create(
      type: :regular,
      options: {
        list_id: Settings.mailchimp.list_id,
        subject: subject,
        from_email: Settings.mailchimp.from_email,
        from_name: Settings.mailchimp.from_name,
        template_id: Settings.mailchimp.template_id,
        analytics: {
          google: subject[0...50]  # 50 character maximum,
        },
      },
      content: {
        sections: {
          main: content,
          adimage: advertisement,
          issuedate: issue_date,
        }
      }
    )
    @campaign_id = response['id']
  end

  def send_campaign!
    if test_email.present?
      @gb.campaigns.send_test(cid: @campaign_id, test_emails: [test_email])
      "Campaign draft sent to #{test_email}"
    elsif scheduled_time.present?
      time_repr = scheduled_time.utc.strftime("%F %T")
      @gb.campaigns.schedule(cid: @campaign_id, schedule_time: time_repr)
      "Campaign scheduled to be sent at " +
        scheduled_time.strftime('%r on %D %Z')
    else
      @gb.campaigns.send_now(cid: @campaign_id)
      "Campaign was sent"
    end
  end

  protected
  def issue_date
    Date.today.to_s
  end

  private
  def advertisement
    # TODO: make this configurable by non-developers
    src = "http://#{Settings.content_cdn}/advertisements/#{Settings.mailchimp.ad_image}"
    %{<a href="#{Settings.mailchimp.ad_href}"><img src="#{src}"/></a>}
  end

end

class ArticleNewsletter < Newsletter
  attr_accessor :article


  def initialize(attributes={})
    super
    if attributes[:article]
      @article = Article.find(attributes[:article], include: :authors)
    end
  end

  def content
    # TODO: look into executing in an actual controller context with helpers
    template = File.read(File.join(%w{app views newsletter article.html.haml}))
    Haml::Engine.new(template).render(Rails.application.routes.url_helpers, article: @article)
  end

  def self.model_name
    Newsletter.model_name
  end

  private
  def subject
    "Chronicle Alert: #{@article.title}"
  end
end

class DailyNewsletter < Newsletter
  NEWSLETTER_PAGE_PATH = '/newsletter'


  def initialize(attributes={})
    super
    @model = Page.find_by_path!(NEWSLETTER_PAGE_PATH).layout.model
  end

  def content
    # TODO: look into executing in an actual controller context with helpers
    template = File.read(File.join(%w{app views newsletter daily.html.haml}))
    Haml::Engine.new(template).render(Rails.application.routes.url_helpers, model: @model)
  end

  def self.model_name
    Newsletter.model_name
  end

  private
  def subject
    "Duke Chronicle Daily Newsletter #{issue_date}"
  end
end
