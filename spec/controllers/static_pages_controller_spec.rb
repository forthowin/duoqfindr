require 'rails_helper'

describe StaticPagesController do
  describe 'GET home' do
    it 'redirects to the search page for logged in users' do
      session[:user_id] = Fabricate(:user).id
      get :home
      expect(response).to redirect_to search_path
    end
  end
end