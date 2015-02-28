class ConversationsController < ApplicationController
  def index
    @mailbox = current_user.mailbox
  end

  def show
    @conversation = current_user.mailbox.conversations.find(params[:id])
  end
end