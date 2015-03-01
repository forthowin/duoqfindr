class MessagesController < ApplicationController
  before_action :require_user

  def create
    user = User.find_by username: params[:username]

    current_user.send_message(user, params[:body], params[:subject])

    flash[:notice] = "Message sent!"
    redirect_to user_path(user)
  end

  def reply
    conversation = current_user.mailbox.conversations.find(params[:id])

    current_user.reply_to_conversation(conversation, params[:reply_body])

    flash[:notice] = "Message sent!"
    redirect_to conversation_path(conversation)
  end
end