class User < ActiveRecord::Base
	has_many :microposts,dependent: :destroy#依赖关系删除用户时删除微博
	# 手动指定外键的名字。默认会是relationship_id
	has_many :relationships,foreign_key: "follower_id",dependent: :destroy
	 # 创建属性:followeds,通过user.followeds获取到,relationships表中的followed_id数组
	 # has_many :followeds, through: :relationships
	 #创建属性:followed_users,通过user.followed_users获取到,relationships表中的followed_id数组
	 #source指定需要获取的是followed_id列
	has_many :followed_users, through: :relationships, source: :followed
	has_many :followers, through: :relationships, source: :follower
	# 虚拟reverse_relationships表
	has_many :reverse_relationships, foreign_key: "followed_id",
					 class_name:  "Relationship",
					 dependent:   :destroy
	has_many :followers, through: :reverse_relationships
	# source默认为 followers的单数
	# has_many :followers, through: :reverse_relationships, source: :follower#完整写法


	validates :name, presence: true, 
		length: { maximum: 50, minimum:4 }
	validates :email, presence: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, 
			format: { with: VALID_EMAIL_REGEX },
			uniqueness:  { case_sensitive: false }
	validates :password, length: { minimum: 6 }
	has_secure_password
	# before_save { self.email = email.downcase }简写形式
	before_save { email.downcase! }
	# 在用户存入数据库之前生成记忆权标
	before_create :create_remember_token
 
	# 创建的字符串长度为 16，由 A-Z、a-z、0-9、下划线（_）和连字符（-）组成
	# （每一位字符都有 64 种可能的情况，所以叫做“base64”）.
	# 所以两个记忆权标相等的概率就是 1/64^16 = 2^-96 ≈ 10^-29
	def self.new_remember_token
		SecureRandom.urlsafe_base64
	end

	# 这种哈希算法比用来加密用户密码的 Bcrypt 速度快得多。
	# 加密后的记忆权标是 16 位随机字符
	def self.hash(token)
		# 之所以调用 to_s，是为了处理输入为 nil 的情况，
		# 在浏览器中不会遇到，测试时偶尔会出现
		Digest::SHA1.hexdigest(token.to_s)
	end

	# 动态列表的初步实现
	def feed
		# This is preliminary. See "Following users" for the full implementation.
		# Micropost.where("user_id = ?", id) # == microposts
		Micropost.from_users_followed_by(self)
	end
	# 是否被关注
	def following?(other_user)
		relationships.find_by(followed_id: other_user.id)
	end
	# 添加关注
	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end
	# 取消关注
 	def unfollow!(other_user)
		relationships.find_by(followed_id: other_user.id).destroy
	end
	private

		def create_remember_token
			self.remember_token = User.hash(User.new_remember_token) 
		end
end
