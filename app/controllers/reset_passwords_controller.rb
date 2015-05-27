class ResetPasswordsController < ApplicationController
  def show
    user = User.where(forgot_password_token: params[:id]).first
    if user
      @token = user.forgot_password_token
    else
      redirect_to invalid_token_path
    end
  end

  def create
    user = User.where(forgot_password_token: params[:token]).first
    if user
      if user.update(forgot_password_token: nil, password: params[:password])
        flash[:success] = "Your password has been updated."
        redirect_to login_path
      else
        flash[:danger] = "Password cannot be blank."
        redirect_to reset_password_path(params[:token])
      end
    else
      redirect_to invalid_token_path
    end
  end
end