class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:show]
  
  def show
    if params[:id] == current_user.id.to_s
      @user = User.find(params[:id])
      @tasks = @user.tasks.order('created_at DESC').page(params[:page])
      counts(@user)
    else
      flash[:danger] = '他のユーザのプロフィールは表示できません。'
      redirect_to root_url
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
end

private

def user_params
  params.require(:user).permit(:name, :email, :password, :password_confirmation)
end
