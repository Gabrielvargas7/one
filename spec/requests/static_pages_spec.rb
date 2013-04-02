require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_selector('h1',    text: 'Sample App') }
    it { should have_selector('title', text: full_title('Home')) }
    it { should have_selector 'title', text: 'Home' }
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_selector('h1',    text: 'Help') }
    it { should have_selector('title', text: full_title('Help')) }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_selector('h1',    text: 'About') }
    it { should have_selector('title', text: full_title('About Us')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_selector('h1',    text: 'Contact') }
    it { should have_selector('title', text: full_title('Contact')) }
  end
end


#describe "Static pages" do
#
#  let(:base_title){"Ruby and Rails Tutorial Sample App"}
#
#  subject { page }
#
#  describe "Home page" do
#    before {visit root_path}
#    it do
#      should have_selector('h1', test: 'Sample App')
#    end
#      #visit root_path
#      #page.should have_content('ppp')
#    end
#
#    it "should have the right base title" do
#      #visit root_path
#      page.should have_selector('title',:test=> "#{base_title}")
#    end
#
#    it "should have the right title" do
#      #visit root_path
#      page.should have_selector('title',:test=>"Home")
#
#    end
#
#
#  end
#
#  describe "Help page" do
#    it "should have the content 'Help'" do
#      visit help_path
#
#      page.should have_content('Help')
#    end
#    it "should have the right title" do
#      visit help_path
#      page.should have_selector('title',:test=>"#{base_title} | Help")
#
#    end
#
#  end
#  describe "About Page" do
#    it "should have the content 'About Us'" do
#      #visit '/static_pages/about'
#      visit about_path
#      page.should have_content('About Us')
#    end
#    it "should have the right title" do
#      visit about_path
#      page.should have_selector('title',:test=>"#{base_title} | About")
#
#    end
#  end
#
#  describe "Contact" do
#    it "should have the content 'Contact'" do
#      visit contact_path
#      page.should have_content('Contact');
#    end
#    it "should have the right title" do
#      visit contact_path
#      page.should have_selector('title',:test=>"#{base_title} | Contact")
#
#    end
#
#  end
#end
