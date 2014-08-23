class RelationshipsController < ApplicationController
  before_action :signed_in_user
  # 提取respond_to
  respond_to :html, :js

  def create
    @user = User.find_by(id: params[:relationship][:followed_id])
    current_user.follow!(@user)
    # redirect_to @user
    # 相应Ajax请求
    # respond_to do |format|
    #   # 只有一行会被执行（依据请求的类型而定）
    #   format.html { redirect_to @user }
    #   format.js
    # end
    # 重构Ajax
    respond_with @user
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    # redirect_to @user
    # 相应Ajax请求
    # respond_to do |format|
    #   format.html { redirect_to @user }
    #   format.js
    # end
   # 重构Ajax
    respond_with @user
  end
end
