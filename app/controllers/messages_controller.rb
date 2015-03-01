class MessagesController < ApplicationController
  before_action :require_user

  def create
    user = User.find_by username: params[:username]

    if params[:body].blank? or params[:subject].blank?
      flash[:danger] = "Subject and body must be present."
      redirect_to :back
    else
      current_user.send_message(user, params[:body], params[:subject])
      flash[:notice] = "Message sent!"
      redirect_to user_path(user)
    end
  end

  def reply
    conversation = current_user.mailbox.conversations.find(params[:id])

    if params[:reply_body].blank?
      flash[:danger] = "Reply body can't be blank"
      redirect_to :back
    else
      current_user.reply_to_conversation(conversation, params[:reply_body])
      flash[:notice] = "Message sent!"
      redirect_to conversation_path(conversation)
    end
  end
end