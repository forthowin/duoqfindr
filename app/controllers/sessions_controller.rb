class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]

  def new
  end

  def create
    user = User.find_by username: params[:username]

    if user and user.authenticate(params[:password])
      if user.ip_address != request.ip #update ip address
        user.ip_address = request.ip
        user.save
      end
      session[:user_id] = user.id
      flash[:notice] = "You have successfully log in"
      redirect_to root_path
    else
      flash.now[:danger] = "Wrong username or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have successfully signed out"
    redirect_to root_path
  end
end