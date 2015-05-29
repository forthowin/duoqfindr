class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]
  before_action :logged_in_redirect, only: [:new, :create]

  def new
  end

  def create
    user = User.where('lower(username) = ?', params[:username].downcase).first

    if user and user.authenticate(params[:password])
      update_ip_address
      session[:user_id] = user.id
      flash[:success] = "You have successfully log in"
      redirect_to search_path
    else
      flash.now[:danger] = "Wrong username or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have successfully signed out"
    redirect_to root_path
  end

  private

  def logged_in_redirect
    if current_user
      flash[:info] = 'You are already logged in'
      redirect_to search_path
    end
  end

  def update_ip_address
    if user.ip_address != request.ip
      user.update_column(:ip_address, request.ip)
    end
  end
end