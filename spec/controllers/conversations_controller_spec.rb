require 'rails_helper'

describe ConversationsController do
  describe 'GET show' do
    context 'with an existing id' do
      it 'assigns the conversation' do
        bob = Fabricate(:user)
        bill = Fabricate(:user)
        set_current_user(bob)
        bob.send_message(bill, 'subject', 'body')
        get :show, id: bob.mailbox.conversations.first.id
        expect(assigns(:conversation)).to eq(bob.mailbox.conversations.first)
      end
    end

    context 'with a non-existing id' do
      let(:bob) { Fabricate(:user) }
      
      before do
        set_current_user(bob)
        get :show, id: 999
      end

      it 'sets the flash danger message' do
        expect(flash[:danger]).to be_present
      end

      it 'redirects to the user inbox' do
        expect(response).to redirect_to conversations_path
      end
    end
  end
end