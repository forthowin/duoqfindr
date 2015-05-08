require 'rails_helper'

describe SearchesController do
  describe 'POST update' do
    it 'redirects to the sign in page for unauthorized users' do
      post :update, radius: "100"
      expect(response).to redirect_to login_path
    end

    it 'renders the show page' do
      set_current_user
      post :update, radius: "100"
      expect(response).to render_template :show
    end

    it 'sets the flash danger message for invalid inputs' do
      set_current_user
      post :update, radius: "160"
      expect(flash[:danger]).to be_present
    end

    it 'assigns users for valid inputs' do
      bob = Fabricate(:user, latitude: 0, longitude: 0)
      tim = Fabricate(:user, latitude: 0, longitude: 0)
      jim = Fabricate(:user, latitude: 0, longitude: 0)
      set_current_user(bob)
      post :update, radius: "100"
      expect(assigns(:users)).to eq([tim, jim])
    end

    it 'sets the flash info message when no one was found' do
      bob = Fabricate(:user, latitude: 0, longitude: 0)
      set_current_user(bob)
      post :update, radius: '100'
      expect(flash[:info]).to be_present
    end
  end
end