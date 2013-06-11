class Newsletter
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :test_email, :scheduled_time


  def initialize(attributes)
    @test_email = attributes[:test_email] if attributes
    @scheduled_time = attributes[:scheduled_time] if attributes
  end

  def persisted?
    false
  end

  def send_campaign
    gb = Gibbon.new(Settings.mailchimp.api_key)
    cid = create_campaign(gb)
    if test_email.nil?
      gb.campaign_send_now(cid: cid)
    else
      gb.campaign_send_test(cid: cid, test_emails: [test_email])
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

  def create_campaign(gb)
    gb.campaign_create({
      type: :regular,
      options: {
        list_id: Settings.mailchimp.list_id,
        subject: subject,
        from_email: Settings.mailchimp.from_email,
        from_name: Settings.mailchimp.from_name,
        template_id: Settings.mailchimp.template_id,
        analytics: {
          google: subject,
        },
      },
      content: {
        html_MAIN: content,
        html_ADIMAGE: advertisement,
        html_ISSUEDATE: issue_date,
      },
    })
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
