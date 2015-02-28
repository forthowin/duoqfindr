class ConversationsController < ApplicationController
  before_action :require_user
  
  def index
    @mailbox = current_user.mailbox
  end

  def show
    @conversation = current_user.mailbox.conversations.find(params[:id])
  end
end