require 'rails_helper'

describe UsersController do
  describe 'GET new' do
    it 'creates a new @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST create' do
    context 'with valid inputs' do
      before { post :create, user: Fabricate.attributes_for(:user) }

      it 'saves the user' do
        expect(User.count).to eq(1)
      end

      it 'redirects to their edit profile page' do
        expect(response).to redirect_to edit_user_path(User.first)
      end

      it 'sets the flash notice message' do
        expect(flash[:notice]).to be_present
      end

      it 'saves the user id into the session' do
        expect(session[:user_id]).to eq(User.first.id)
      end

      it "saves the user's ip address" do
        expect(User.first.ip_address).to be_present
      end
    end

    context 'with invalid inputs' do
      before { post :create, user: Fabricate.attributes_for(:user, username: nil) }

      it 'does not create a user' do
        expect(User.count).to eq(0)
      end

      it 'sets the @user' do
        expect(assigns(:user)).to be_an_instance_of(User)
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET show' do
    it 'finds the user by the slug' do
      bob = Fabricate(:user)
      get :show, id: bob.slug
      expect(assigns(:user)).to eq bob
    end
  end

  describe 'GET edit' do
    it 'finds the user by the slug if the user is the same' do
      bob = Fabricate(:user)
      set_current_user(bob)
      get :edit, id: bob.slug
      expect(assigns(:user)).to eq bob
    end

    it 'redirects to the root path if the user is different'
    it 'redirects to the sign in page for unauthorized user'
  end
end