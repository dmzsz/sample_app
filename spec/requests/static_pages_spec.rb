require 'spec_helper'

describe "Static pages" do

  let (:base_title) { "Ruby on Rails Tutorial Sample App" }

  shared_examples_for "all static pages" do
    # subject {page} # outer it{...} errr: undefined method `has_content?' ...
    # it { should have_content(heading) }
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    
    # before (:each){ 
    #   visit  root_path 
    # }
    # before :each do
    #   visit root_path
    # end
    before  {visit root_path}
    subject {page}

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


    # it { should have_content ('Sample App') }
    # it { should have_selector ('h1', text: 'Sample App') }
    # it { should have_title ("#{base_title}") }
    it { should have_title (full_title('')) }
    # it { should_not have_title ('| Home') }


    let (:heading) { 'Sample App' }
    let (:page_title) { '' }
    it_should_behave_like "all static pages"

  end

  describe "Help page" do

    before  { visit help_path }
    subject { page }
    
    # it "should have the content 'Help'" do
    #   # visit '/static_pages/help'
    #   #visit help_path
    #   #expect(page).to have_content('Help')
    #   should have_content ('Help')
    # end
    # it { should have_content('Help') }

    # it "should have the title 'Help'" do
    #   # visit '/static_pages/help'
    #   #visit help_path
    #   #expect(page).to have_title ("#{base_title} | Help")
    #   should have_title ("#{base_title} | Help")
    # end
    # it { should have_title("#{base_title} | Help") }
    # it { should have_title (full_title('Help')) }

    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }
    it_should_behave_like "all static pages"
    
  end

  describe "About page" do
    before  { visit about_path }
    subject { page }

    # it "should have the content 'About Us'" do
    #   # visit '/static_pages/about'
    #   # visit about_path
    #   # expect(page).to have_content('About Us')
    #   should have_content ('About Us')
    # end
    # it { should have_content ('About Us') }

    # it "should have the title 'About Us'" do
    #   # visit '/static_pages/about'
    #   # visit about_path
    #   # expect(page).to have_title("#{base_title} | About Us")
    #   should have_title ("#{base_title} | About Us")
    # end
    # it { should have_title ("#{base_title} | About Us") }
    # it { should have_title (full_title('About Us')) }

    let (:heading) { 'About Us' }
    let (:page_title) { 'About Us' }
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before  { visit contact_path }
    subject {page}

    # it "should have the content 'Contact'" do
    #   # visit '/static_pages/contact'
    #   # visit contact_path
    #   # expect(page).to have_content('Contact')
    #   should have_content ('Contact')
    # end
    # it { should have_content ('Contact')}


    # it "should have the title 'Contact'" do
    #   # visit '/static_pages/contact'
    #   # visit contact_path
    #   # expect(page).to have_title("#{base_title} | Contact")
    #   should have_title ("#{base_title} | Contact")
    # end
    # it { should have_title ("#{base_title} | Contact")}
    # it {should have_title (full_title ('Contact'))}

    let (:heading) { 'Contact' }
    let (:page_title) { 'Contact' }
    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end

  

end
