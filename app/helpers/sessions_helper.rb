module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token
    # 因为开发者经常要把 cookie 的失效日期设为 20 年后，所以 Rails 特别提供了 permanent 方法
    cookies.permanent[:remember_token] = remember_token
    # 这样可以跳过数据验证更新单个属性。这样可以跳过数据验证更新单个属性
    user.update_attribute(:remember_token, User.hash(remember_token))
    # 并不一定要把 user 指定为当前用户，因为 create 动作完成后回立即转向models/user.rb
    # 不过指定也好，防止无需转向的登录操作
    self.current_user = user
  end
  
  def sign_out
    if User.find_by :remember_token.blank?
      current_user.update_attribute(:remember_token,
                                  User.hash(User.new_remember_token))
    end
    # current_user.update_attribute(:remember_token,User.hash(User.new_remember_token))
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    # 程序不会记住用户的登录状态。一旦用户转到其他的页面，session 就失效了，会自动退出。
    # 所以不要使用这一行 
    # @current_user
    remember_token = User.hash(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

 def signed_in?
    !current_user.nil?#current是上面刚刚定义的方法，链式调用java
  end
end
