class Micropost < ActiveRecord::Base
	belongs_to :user
	# 所有的作用域都需要通过匿名函数的方式定义，函数的返回值为所需的条件。
	# 这么做主要的好处是，作用域的条件不用立即计算，只在需要时才执行（“惰性计算”）
		default_scope -> { order('created_at DESC') }#Proc 或 lambda对象
	validates:user_id,presence:true
	validates :content, presence: true, length: { maximum: 140 }
		validates :user_id, presence: true

	def self.from_users_followed_by(user)
		# user.followed_users.map{|i|i.id}
		# user.followed_users.map(&:id)
		# followed_user_ids = user.followed_user_ids
		# where("user_id IN (:followed_user_ids) OR user_id = :user_id",
		# 	followed_user_ids: followed_user_ids, user_id: user)
		# 子查询
		followed_user_ids = "SELECT followed_id FROM relationships
			WHERE follower_id = :user_id"
		where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
			user_id: user.id)
		
	end
end
