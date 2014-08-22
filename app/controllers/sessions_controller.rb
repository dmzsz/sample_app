class SessionsController < ApplicationController
	def new

	end
	# 创建session
	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			sign_in user #因为在application_controller.rb中添加了include SessionsHelper.
			# redirect_to user#没有这一句会自动找sessions/create.html.erb的
			redirect_back_or user 
		else
			# flash.now 就是专门用来在重新渲染的页面中显示 Flash 消息的，
			# 在发送新的请求之后，Flash 消息便会消失
			flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
