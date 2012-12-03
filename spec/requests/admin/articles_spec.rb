require 'spec_helper'

describe "Admin::Articles" do
  subject { page }

  describe "creation" do
    before do
      default_url_options[:host] = "lvh.me"
      default_url_options[:port] = "3000"
      visit new_admin_article_url(:subdomain => :admin)
    end

    describe "with invalid information" do
      it "should not create an article" do
        expect { click_button "Submit" }.not_to change(Article, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create an Article" do
        expect { click_button "Submit" }.to change(Article, :count).by(1)
      end
    end
  end
end
