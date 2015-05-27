class AppMailer < ActionMailer::Base
  def send_forgot_password(user)
    @user = user
    mail to: user.email, from: "info@duoqfindr.com", subject: "Reset password confirmation"
  end
end