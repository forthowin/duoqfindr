require 'rails_helper'

describe MessagesController do
  describe 'POST create' do
    context 'with valid inputs' do
      let(:bob) { Fabricate(:user) }
      let(:tim) { Fabricate(:user) }

      before do
        set_current_user(bob)
        post :create, username: tim.username, body: "Hey", subject: "Hi"
      end

      it 'redirects to the user show page' do
        expect(response).to redirect_to user_path tim
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'sends the message to the user' do
        expect(tim.mailbox.conversations.count).to eq(1)
      end
    end

    context 'with blank inputs' do
      let(:bob) { Fabricate(:user) }
      let(:tim) { Fabricate(:user) }

      before do
        request.env["HTTP_REFERER"] = "/users/#{tim.slug}"
        set_current_user(bob)
      end

      it 'sets the flash danger message' do
        post :create, username: tim.username, body: nil, subject: nil
        expect(flash[:danger]).to be_present
      end

      it 'redirects back to the previous page' do
        post :create, username: tim.username, body: nil, subject: nil
        expect(response).to redirect_to user_path(tim)
      end

      it 'redirects back to the previous page if the user could not be found' do
        post :create, username: nil, body: nil, subject: nil
        expect(response).to redirect_to user_path(tim)
      end
    end
  end

  describe 'POST reply' do
    context 'with valid inputs' do
      let(:bob) { Fabricate(:user) }
      let(:tim) { Fabricate(:user) }

      before do
        set_current_user(bob)
        bob.send_message(tim, 'body', 'subject')
        post :reply, id: tim.mailbox.conversations.first.id, reply_body: 'Hey'
      end

      it 'redirects to the conversation page' do
        expect(response).to redirect_to conversation_path tim.mailbox.conversations.first
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'sends the message to the user' do
        expect(tim.mailbox.conversations.first.receipts_for(tim).count).to eq(2)
      end
    end

    context 'with blank inputs' do
      let(:bob) { Fabricate(:user) }
      let(:tim) { Fabricate(:user) }
      let(:conv) { bob.send_message(tim, 'body', 'subject') }

      before do
        request.env["HTTP_REFERER"] = "/conversations/#{conv.id}"
        set_current_user(bob)
        post :reply, id: tim.mailbox.conversations.first.id, reply_body: nil
      end

      it 'sets the flash danger message' do
        expect(flash[:danger]).to be_present
      end

      it 'redirects back to the previous page' do
        expect(response).to redirect_to conversation_path conv
      end
    end
  end
end