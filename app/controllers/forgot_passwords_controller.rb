class ForgotPasswordsController < ApplicationController
  def new
  end

  def confirm
  end

  def create
    user = User.where('lower(email) = ?', params[:email].downcase).first
    if user
      user.update_column(:forgot_password_token, user.generate_token)
      AppMailer.send_forgot_password(user).deliver_later
      redirect_to forgot_password_confirmation_path
    else
      flash[:danger] = params[:email].blank? ? "Email cannot be blank." : "Cannot find user with that email."
      redirect_to new_forgot_password_path
    end
  end
end