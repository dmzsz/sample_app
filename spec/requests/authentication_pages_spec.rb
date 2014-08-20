require 'spec_helper'

describe "Authentication" do
	subject { page }

	describe "signin page" do
		before { visit signin_path }

		it { should have_content('Sign in') }
		it { should have_title('Sign in') }
	end

	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign in" }

			it { should have_title('Sign in') }
			it { should have_selector('div.alert.alert-danger') }
			it {should have_danger_message :Invalid}

			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-danger') }
				it { should_not have_danger_message :Invalid}
			end
		end

		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				valid_signin user
			end

			it { should have_title(user.name) }
			it { should have_link('Profile',     href: user_path(user)) }
			it { should have_link('Sign out',    href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }

			describe "followed by signout" do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end
		end
		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before { sign_in user }

			it { should have_title(user.name) }
			it { should have_link('Profile',     href: user_path(user)) }
			it { should have_link('Settings',    href: edit_user_path(user)) }
			it { should have_link('Sign out',    href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }
		end
	end
	#权限测试
	describe "authorization" do
		#没有登陆的用户测试
		describe "for non-signed-in users" do
			let(:user) { FactoryGirl.create(:user) }
			
			# 测试 edit 和 update 动作是否处于被保护状态
			describe "in the Users controller" do
				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { should have_title('Sign in') }
				end
				describe "submitting to the update action" do
					before { patch user_path(user) }
					#undefined method `assertions' for #<RSpec::Rails::TestUnitAssertionAdapter::AssertionDelegator:0x0000000606bef8>`
					specify { expect(response).to redirect_to(signin_path) }
				end
			end
			# 测试更友好的转向,无权修改资料的用户，自动跳转到登陆页面
			describe "when attempting to visit a protected page" do
				before do
					visit edit_user_path(user)#创建了user却没有登陆直接进入edit_edit_path
					fill_in "Email",    with: user.email#页面被强制跳转到了登陆页面
					fill_in "Password", with: user.password
					click_button "Sign in"
				end		
				describe "after signing in" do
					it "should render the desired protected page" do
						expect(page).to have_title('Edit user')
					end
					describe "when signing in again" do
						before do
							click_link 'Sign out'
							visit signin_path
							fill_in "Email",    with: user.email
							fill_in "Password", with: user.password
							click_button "Sign in"
						end
						it "should render the default (profile) page" do
							expect(page).to have_title(user.name)
						end
					end
				end
			end
			# 测试 index 动作是否是被保护的
			describe "in the Users controller" do
				describe "visiting the user index" do
					before { visit users_path }
					it { should have_title('Sign in') }
				end
			end
		end

		# 测试只有自己才能访问 edit 和 update 动作
		describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
			before { sign_in user, no_capybara: true }#跳过默认的登录操作，直接处理 cookie
								describe "submitting a GET request to the Users#edit action" do
				before { get edit_user_path(wrong_user) }
				specify { expect(response.body).not_to match(full_title('Edit user')) }
				specify { expect(response).to redirect_to(root_url) }
			end
			describe "submitting a PATCH request to the Users#update action" do
				before { patch user_path(wrong_user) }
				specify { expect(response).to redirect_to(root_url) }
			end
		end
		
		# 检测“Users”链接的测试
		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before { sign_in user }
			it { should have_title(user.name) }
			it { should have_link('Users',       href: users_path) }
			it { should have_link('Profile',     href: user_path(user)) }
			it { should have_link('Settings',    href: edit_user_path(user)) }
			it { should have_link('Sign out',    href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }
		end
		# 测试访问受限的 destroy 动作
		describe "as non-admin user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) { FactoryGirl.create(:user) }
			before { sign_in non_admin, no_capybara: true }
			describe "submitting a DELETE request to the Users#destroy action" do
				before { delete user_path(user) }
				specify { expect(response).to redirect_to(root_path) }
			end
		end

	end
end
