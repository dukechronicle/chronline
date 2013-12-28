class Newsletter
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :campaign_id, :scheduled_time, :test_email


  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value)
    end
    @gb = Gibbon::API.new(ENV['MAILCHIMP_API_KEY'])
  end

  def persisted?
    false
  end

  def create_campaign
    response = @gb.campaigns.create(
      type: :regular,
      options: {
        list_id: ENV['MAILCHIMP_LIST_ID'],
        subject: subject,
        from_email: ENV['MAILCHIMP_FROM_EMAIL'],
        from_name: ENV['MAILCHIMP_FROM_NAME'],
        template_id: ENV['MAILCHIMP_TEMPLATE_ID'],
        analytics: {
          google: subject[0...50]  # 50 character maximum,
        },
      },
      content: {
        sections: {
          preheader_content00: teaser,
          header_image: header,
          left_column_lead: column_lead(0),
          right_column_lead: column_lead(1),
          body_content: content,
          advertisement_content: advertisement,
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
      @gb.campaigns.send(cid: @campaign_id)
      "Campaign was sent"
    end
  end

  protected
  def issue_date
    Date.today.to_s
  end

  def render(template, locals)
    # TODO: look into executing in an actual controller context with helpers
    template = File.read(
      Rails.root.join('app', 'views', 'newsletter', "#{template}.html.haml"))
    Haml::Engine.new(template)
      .render(Rails.application.routes.url_helpers, locals)
  end

  private
  def advertisement
    src = "https://#{ENV['CONTENT_CDN']}/advertisements/#{Sitevar.mailchimp_ad_image}"
    render(:advertisement, href: Sitevar.mailchimp_ad_href, image: src)
  end

  def column_lead(i)
    ""
  end

  def teaser
    ""
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
    render(:article, article: @article)
  end

  def self.model_name
    Newsletter.model_name
  end

  private
  def subject
    "Chronicle Alert: #{@article.title}"
  end

  private
  def header
    src = "https://s3.amazonaws.com/chronline/newsletter/alert_header.png"
    %{<img src="#{src}" style="max-width:600px;" id="headerImage" alt="The Chronicle Breaking News Alert" /></a>}
  end
end

class DailyNewsletter < Newsletter
  NEWSLETTER_PAGE_PATH = '/newsletter'


  def initialize(attributes={})
    super
    @model = Page.find_by_path!(NEWSLETTER_PAGE_PATH).layout.model
  end

  def content
    render(:daily, model: @model)
  end

  def column_lead(i)
    render(:featured, article: @model.featured[i])
  end

  def self.model_name
    Newsletter.model_name
  end

  private
  def subject
    "Duke Chronicle Daily Newsletter #{issue_date}"
  end

  private
  def header
    src = "https://s3.amazonaws.com/chronline/newsletter/daily_header.png"
    %{<img src="#{src}" style="max-width:600px;" id="headerImage" alt="The Chronicle Daily Newsletter" /></a>}
  end

  def teaser
    @model.teaser || super
  end
end
