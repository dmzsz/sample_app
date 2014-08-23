require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "signup page" do
		before { visit signup_path }

		it { should have_content('Sign up') }
		it { should have_title(full_title('Sign up')) }
	end

	describe "after saving the user" do
		before { click_button submit }
		let(:user) { User.find_by(email: 'user@example.com') }

		it { should have_link('Sign out') }
		it { should have_title(user.name) }
		it { should have_selector('div.alert.alert-success', text: 'Welcome') }
	end  

	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			# sign_in user
			visit edit_user_path(user)
		end
		describe "page" do
			it { should have_content("Update your profile") }
			it { should have_title("Edit user") }
			it { should have_link('change', href: 'http://gravatar.com/emails') }
		end
		describe "with invalid information" do
			before { click_button "Save changes" }
			it { should have_content('error') }
		end
		describe "with valid information" do
			let(:new_name)  { "New Name" }
			let(:new_email) { "new@example.com" }
			before do
				fill_in "Name",		with: new_name
				fill_in "Email", 		with: new_email
				fill_in "Password", 	with: user.password
				fill_in "Confirm Password", with: user.password
				click_button "Save changes"
			end
			it { should have_title(new_name) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign out', href: signout_path) }
			specify { expect(user.reload.name).to  eq new_name }
			specify { expect(user.reload.email).to eq new_email }
		end
	end

	describe "index" do
		before do
			sign_in FactoryGirl.create(:user)
			FactoryGirl.create(:user, name: "Bob!!", email: "bob@example.com")
			FactoryGirl.create(:user, name: "Ben!!", email: "ben@example.com")
			visit users_path
		end

		it { should have_title('All users') }
			it { should have_content('All users') }

		it "should list each user" do
			User.all.each do |user|
				expect(page).to have_selector('li', text: user.name)
			end
		end
	end

	
	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
		let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

		before { visit user_path(user) }

		it { should have_content(user.name) }
		it { should have_title(user.name) }
		# 检测用户资料页面是否显示了微博的测试
		describe "microposts" do
			it { should have_content(m1.content) }
			it { should have_content(m2.content) }
			# count 方法会直接在数据库层中统计用户的微博数量,而不是全部取出后length
			it { should have_content(user.microposts.count) }
		end
		# 测试关注和取消关注按钮
		describe "follow/unfollow buttons" do
			let(:other_user) { FactoryGirl.create(:user) }
			before { sign_in user }
			describe "following a user" do
				before { visit user_path(other_user) }
				it "should increment the followed user count" do
					expect do
						click_button "Follow"
					end.to change(user.followed_users, :count).by(1)
				end
				it "should increment the other user's followers count" do
					expect do
						click_button "Follow"
					end.to change(other_user.followers, :count).by(1)
				end
				describe "toggling the button" do
					before { click_button "Follow" }
					it { should have_xpath("//input[@value='Unfollow']") }
				end
			end
			describe "unfollowing a user" do
				before do
					user.follow!(other_user)
					visit user_path(other_user)
				end
				it "should decrement the followed user count" do
					expect do
						click_button "Unfollow"
					end.to change(user.followed_users, :count).by(-1)
				end
				it "should decrement the other user's followers count" do
					expect do
						click_button "Unfollow"
					end.to change(other_user.followers, :count).by(-1)
				end
				describe "toggling the button" do
					before { click_button "Unfollow" }
					it { should have_xpath("//input[@value='Follow']") }
				end
			end
		end
	end

	# 测试关注列表和粉丝列表页面
	describe "following/followers" do
		let(:user) { FactoryGirl.create(:user) }
		let(:other_user) { FactoryGirl.create(:user) }
		before { user.follow!(other_user) }

		describe "followed users" do
			before do
				sign_in user
				visit following_user_path(user)
			end

			it { should have_title(full_title('Following')) }
			it { should have_selector('h3', text: 'Following') }
			it { should have_link(other_user.name, href: user_path(other_user)) }
		end

		describe "followers" do
			before do
				sign_in other_user
				visit followers_user_path(other_user)
			end

			it { should have_title(full_title('Followers')) }
			it { should have_selector('h3', text: 'Followers') }
			it { should have_link(user.name, href: user_path(user)) }
		end
	end
end