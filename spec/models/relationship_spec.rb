require 'spec_helper'

describe Relationship do

	let(:follower) { FactoryGirl.create(:user) }
	let(:followed) { FactoryGirl.create(:user) }
	let(:relationship) { follower.relationships.build(followed_id: followed.id) }

	subject { relationship }

	it { should be_valid }
	
	# 测试 User 和 Relationship 模型之间的 belongs_to 关系
	 describe "follower methods" do
		it { should respond_to(:follower) }
		it { should respond_to(:followed) }
		its(:follower) { should eq follower }
		its(:followed) { should eq followed }
	end
	# 测试 Relationship 模型的数据验证
	 describe "when followed id is not present" do
		before { relationship.followed_id = nil }
		it { should_not be_valid }
	end

	describe "when follower id is not present" do
		before { relationship.follower_id = nil }
		it { should_not be_valid }
	end
end