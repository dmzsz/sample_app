class UsersController < ApplicationController
	#默认情况下，事前过滤器会应用于控制器中的所有动作.
	# :only 参数指定只应用在 edit 和 update 动作上
	before_action :signed_in_user, only: [:index,:edit, :update]
	before_action :correct_user, only: [:edit, :update]
	before_action :admin_user, 	only: :destroy
	def index
		# @users=User.all
		@users = User.paginate(page: params[:page])
	end
	def show
		# 查询为id的user
		@user = User.find(params[:id])
	end
	
	def new
		@user=User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
		# @user = User.find(params[:id])#correct_user已经写这一句了
	end
 
	def update
		# @user = User.find(params[:id])
		if @user.update_attributes(user_params)
			sign_out
			redirect_to user_path
			flash[:success] = "Profile updated"
			sign_in @user
		else
			render 'edit'
		end
	end
	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User destroyed."
		redirect_to users_url
	end
	private
	
		def user_params
			#传入整个 params Hash，程序会抛出异常
			params.require(:user).permit(:name, :email, :password,
				:password_confirmation)
		end

		# Before filters
		def signed_in_user
			unless signed_in?
				store_location #记录非法访问的页面，登陆后自动跳转到这个页面
				flash[:warning] = "Please sign in."
				redirect_to signin_url
			end
			# redirect_to signin_url,notice:"Please sign in." unless signed_in?
		end
		#检测当前登陆的id与访问的id是否一直，不一致的话跳转到root_path
		def correct_user
			begin
				@user = User.find(params[:id])
			rescue Exception => raise_record_not_found_exception
				return redirect_to('/404.html') 
			end
      		redirect_to(root_path) unless current_user?(@user)
    	end
		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
end
