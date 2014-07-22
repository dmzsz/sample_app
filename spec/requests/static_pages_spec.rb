require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  describe "Home page" do
    
    # before (:each){ 
    #   visit  root_path 
    # }
    # before :each do
    #   visit root_path
    # end
    before {visit root_path}
    subject{page}

    # it "should have the content 'Sample App'" do
    #   # visit '/static_pages/home'
    #   # visit root_path
    #   expect(page).to have_content('Sample App')
    # end

    # it "should have the title 'Home'" do
    #   # visit '/static_pages/home'
    #   # visit root_path
    #   expect(page).to have_title("#{base_title} | Home")
    # end

    # it "should  no hava a custom page title" do
    #   # visit '/static_pages/home'
    #   # visit root_path
    #   expect(page).not_to have_title('| Home')
    # end

    it{ should have_content('Sample App')}
    # it{ should have_title("#{base_title} | Home")}
    it{should_not have_title(full_title('Home'))}
    it{ should_not have_title('| Home')}
  end

  describe "Help page" do

    it "should have the content 'Help'" do
      # visit '/static_pages/help'
      # visit help_path
      expect(page).to have_content('Help')
    end

    it "should have the title 'Help'" do
      # visit '/static_pages/help'
      # visit help_path
      expect(page).to have_title("#{base_title} | Help")
    end
  end

  describe "About page" do

    it "should have the content 'About Us'" do
      # visit '/static_pages/about'
      # #visit about_path
      expect(page).to have_content('About Us')
    end

    it "should have the title 'About Us'" do
      # visit '/static_pages/about'
      #visit about_path
      expect(page).to have_title("#{base_title} | About Us")
    end
  end

  describe "Contact page" do

    it "should have the content 'Contact'" do
      # visit '/static_pages/contact'
      # visit contact_path
      expect(page).to have_content('Contact')
    end

    it "should have the title 'Contact'" do
      # visit '/static_pages/contact'
      # visit contact_path
      expect(page).to hacontactve_title("#{base_title} | Contact")
    end
  end
end