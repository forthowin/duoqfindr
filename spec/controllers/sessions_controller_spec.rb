require 'rails_helper'

describe SessionsController do
  describe 'POST create' do
    context 'with valid inputs', :vcr do
      let(:bob) { Fabricate(:user, ip_address: '123.123.1.1') }
      before { post :create, username: bob.username, password: bob.password }

      it 'updates the ip address of the user', :vcr do
        expect(bob.reload.ip_address).not_to eq('123.123.1.1')
      end

      it 'sets the flash success message', :vcr do
        expect(flash[:success]).to be_present
      end

      it 'redirects to the root path', :vcr do
        expect(response).to redirect_to search_path
      end
    end

    context 'with invalid inputs' do
      let(:bob) { Fabricate(:user, ip_address: '123.123.1.1') }
      before { post :create, username: bob.username, password: nil }

      it 'sets the flash danger message', :vcr do
        expect(flash[:danger]).to be_present
      end

      it 'renders the new page', :vcr do
        expect(response).to render_template :new
      end
    end

    context 'with a logged in user' do
      before do
        session[:user_id] = Fabricate(:user).id
        post :create, username: 'bob', password: 'password'
      end

      it 'sets the flash info message' do
        expect(flash[:info]).to be_present
      end

      it 'redirects to the search page' do
        expect(response).to redirect_to search_path
      end
    end
  end

  describe 'GET destroy' do
    it 'sets the session user_id to nil' do
      set_current_user
      get :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'sets the flash success message' do
      set_current_user
      get :destroy
      expect(flash[:success]).to be_present
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

  describe 'GET new' do
    context 'with a logged in user' do
      before do
        session[:user_id] = Fabricate(:user).id
        get :new
      end

      it 'sets the flash info message' do
        expect(flash[:info]).to be_present
      end

      it 'redirects to the search page' do
        expect(response).to redirect_to search_path
      end
    end
  end
end