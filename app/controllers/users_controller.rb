class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user=User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
	
  private
	
  def user_params
    #传入整个 params Hash，程序会抛出异常
    params.require(:user).permit(:name, :email, :password,
    	:password_confirmation)
  end
end
