class ConversationsController < ApplicationController
  before_action :require_user
  
  def index
    @mailbox = current_user.mailbox
  end

  def show
    begin
      @conversation = current_user.mailbox.conversations.find(params[:id])
      current_user.mark_as_read(@conversation)
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = 'Could not find conversation'
      redirect_to conversations_path
    end
  end
end