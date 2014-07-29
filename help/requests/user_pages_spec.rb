require 'spec_helper'

describe "UserPages" do
  describe "GET /user_pages" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      # get user_pages_index_path
      get 'users/new'
      response.status.should be(200)
    end
  end
end

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end
end