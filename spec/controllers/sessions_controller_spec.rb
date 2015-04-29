require 'rails_helper'

describe SessionsController do
  describe 'POST create' do
    context 'with valid inputs' do
      it 'updates the ip address of the user' do
        bob = Fabricate(:user, ip_address: '123.123.1.1')
        post :create, username: bob.username, password: bob.password
        expect(bob.reload.ip_address).not_to eq('123.123.1.1')
      end

      it 'sets the flash notice message' do
        bob = Fabricate(:user)
        post :create, username: bob.username, password: bob.password
        expect(flash[:notice]).to be_present
      end

      it 'redirects to the root path' do
        bob = Fabricate(:user)
        post :create, username: bob.username, password: bob.password
        expect(response).to redirect_to search_path
      end
    end

    context 'with invalid inputs' do
      it 'sets the flash danger message' do
        bob = Fabricate(:user)
        post :create, username: bob.username, password: nil
        expect(flash[:danger]).to be_present
      end

      it 'renders the new page' do
        bob = Fabricate(:user)
        post :create, username: bob.username, password: nil
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET destroy' do
    it 'sets the session user_id to nil' do
      set_current_user
      get :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'sets the flash notice message' do
      set_current_user
      get :destroy
      expect(flash[:notice]).to be_present
    end

    it 'redirects to the root path' do
      set_current_user
      get :destroy
      expect(response).to redirect_to root_path
    end

    it 'redirects to the sign in page for unauthorized users' do
      get :destroy
      expect(response).to redirect_to login_path
    end
  end
end