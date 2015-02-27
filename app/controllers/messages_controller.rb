class MessagesController < ApplicationController
  def create
    user = User.find_by username: params[:username]
    binding.pry
    current_user.send_message(user, params[:body], params[:subject])
    flash[:notice] = "Message sent!"
    redirect_to user_path(user)
  end
end