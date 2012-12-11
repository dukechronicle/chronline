require 'spec_helper'

describe "Admin::Articles" do
  subject { page }

  describe "creation" do
    before do
      default_url_options[:host] = "lvh.me"
      default_url_options[:port] = Capybara.current_session.driver.app_server.port
      visit new_admin_article_url(:subdomain => :admin)
    end

    let(:submit) { "Create Article" }

    describe "with invalid information" do
      before { fill_in "Subtitle", with: "Oak arrives just in time" }

      it "should not create an article" do
        p page.html
        expect { click_button :submit }.not_to change(Article, :count)
      end

      it "should display errors" do
        click_button :submit
        find_field("Title").native.next_sibling
          .text.should include("can't be blank")
        find_field("Title").native.parent.parent
          .get_attribute(:class).should include('error')
        find_field("Body").native.next_sibling
          .text.should include("can't be blank")
        find_field("Body").native.parent.parent
          .get_attribute(:class).should include('error')
      end

      it "should fill fields with entered values" do
        click_button :submit
        find_field("Subtitle").value.should == "Oak arrives just in time"
      end
    end

    describe "with valid information" do
      before do
        fill_in "Title", with: "Ash defeats Gary in Indigo Plateau"
        fill_in "Subtitle", with: "Oak arrives just in time"
        fill_in "Teaser", with: "Ash becomes new Pokemon Champion."
        fill_in "Body", with: "**Pikachu** wrecks everyone. The End."
      end

      it "should create an Article" do
        expect { click_button :submit }.to change(Article, :count).by(1)
      end

      it "should create an Article with the correct fields" do
        click_button :submit
        article = Article.find_by_title("Ash defeats Gary in Indigo Plateau")
        article.subtitle.should == "Oak arrives just in time"
        article.teaser.should == "Ash becomes new Pokemon Champion."
        article.taxonomy.should == ['News', 'University']
        article.body.should == "**Pikachu** wrecks everyone. The End."
      end
    end
  end
end
