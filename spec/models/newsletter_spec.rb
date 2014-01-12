require 'spec_helper'


describe Newsletter do
  let(:newsletter) { Newsletter.new }
  let(:mock_gb) { double('Gibbon::API', campaigns: mock_campaigns) }
  let(:mock_campaigns) { double('Gibbon::APICategory') }
  subject { newsletter }

  before do
    newsletter.instance_variable_set('@gb', mock_gb)
    # Abstract newsletter methods must stubbed
    newsletter.stub(
      subject: "Pikachu saves Ash",
      content: "Pikachu attacks a flock of Spearows",
      header: "Pocket Monsters!",
    )
  end

  it { should_not be_persisted }

  describe "#create_campaign" do
    def expect_campaign_create(&proc)
      mock_campaigns.should_receive(:create, &proc).and_return('id' => 12345)
      newsletter.create_campaign
    end

    it "should set campaign_id instance variable" do
      mock_campaigns.should_receive(:create).and_return('id' => 12345)
      newsletter.create_campaign
      newsletter.campaign_id.should == 12345
    end

    it "should create a regular campaign" do
      expect_campaign_create do |options|
        options[:type].should == :regular
      end
    end

    it "should have required Mailchimp options" do
      expect_campaign_create do |options|
        options[:options].should have_key(:list_id)
        options[:options].should have_key(:from_email)
        options[:options].should have_key(:from_name)
        options[:options].should have_key(:template_id)
      end
    end

    it "should use subject method for campaign subject" do
      expect_campaign_create do |options|
        options[:options][:subject].should == "Pikachu saves Ash"
      end
    end

    it "should use Google analytics tracking" do
      expect_campaign_create do |options|
        options[:options][:analytics].should have_key(:google)
      end
    end

    it "should have correct HTML content" do
      expect_campaign_create do |options|
        options[:content][:sections][:body_content].should ==
          "Pikachu attacks a flock of Spearows"
        options[:content][:sections].should have_key(:advertisement_content)
        options[:content][:sections].should have_key(:left_column_lead)
        options[:content][:sections].should have_key(:right_column_lead)
        options[:content][:sections].should have_key(:issuedate)
      end
    end
  end

  describe "#send_campaign!" do
    let(:cid) { 12345 }
    before { newsletter.campaign_id = cid }

    context "when it has test email" do
      before { newsletter.test_email = "pikachu@pallet.town" }

      it "should send a draft email" do
        mock_campaigns.should_receive(:send_test)
          .with(cid: cid, test_emails: ["pikachu@pallet.town"])
        newsletter.send_campaign!
      end
    end

    context "when it has a scheduled time" do
      before do
        newsletter.scheduled_time = DateTime.new(1998, 9, 30, 3, 14)
      end

      it "should schedule the campaign to be sent" do
        mock_campaigns.should_receive(:schedule)
          .with(cid: cid, schedule_time: "1998-09-30 03:14:00")
        newsletter.send_campaign!
      end
    end

    context "when it is not a test nor scheduled" do
      it "should send the campaign immediately" do
        mock_campaigns.should_receive(:send).with(cid: cid)
        newsletter.send_campaign!
      end
    end
  end
end
