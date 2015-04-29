class UsersController < ApplicationController
  before_action :require_user, only: [:edit, :update]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.ip_address = request.ip
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = 'You have successfully registered.'
      redirect_to edit_user_path @user
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Your have successfully updated your profile.'
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find_by slug: params[:id]
  end

  def user_params
    params.require(:user).permit(:username, :role, :tier, :password)
  end

  def require_same_user
    if current_user != @user
      flash[:danger] = "You can't do that."
      redirect_to root_path
    end
  end
end