namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		# 生成100个用户
		admin = User.create!(name: "Example User",
			email: "example@railstutorial.org",
			password: "foobar",
			password_confirmation: "foobar",
			admin: true)		
		99.times do |n|
			name  = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password  = "password"
			User.create!(name: name,
				email: email,
				password: password,
				password_confirmation: password)
		end
		#为前6个用户各创建50篇微博
		users = User.limit(6) #User.all(limit: 6)有误
		50.times do 
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.microposts.create!(content: content) }
		end
	end

end