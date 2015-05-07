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

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
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
    it 'redirects to the login page for unauthorized users' do
      bob = Fabricate(:user)
      get :show, id: bob.slug
      expect(response).to redirect_to login_path
    end

    it 'finds the user by the slug' do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      get :show, id: bob.slug
      expect(assigns(:user)).to eq bob
    end

    it 'caches the summoner data if it is not cache yet' do
      bob = Fabricate(:user, summoner_id: 23472148)
      session[:user_id] = bob.id
      league = double(:riot_api_result, successful?: true, data: 'data')
      get :show, id: bob.slug
      expect(Rails.cache.fetch(bob.summoner_id)).to be_present
    end
  end

  describe 'GET edit' do
    let(:bob) { Fabricate(:user) }

    it 'finds the user by the slug if the user is the same' do
      set_current_user(bob)
      get :edit, id: bob.slug
      expect(assigns(:user)).to eq bob
    end

    it 'redirects to the root path if the user is different' do
      set_current_user
      get :edit, id: bob.slug
      expect(response).to redirect_to root_path
    end

    it 'redirects to the sign in page for unauthorized user' do
      get :edit, id: bob.slug
      expect(response).to redirect_to login_path
    end
  end

  describe 'POST update' do
    context 'with valid inputs' do
      let(:bob) { Fabricate(:user) }

      before do
        set_current_user(bob)
        patch :update, id: bob.slug, user: { role: 'Jungle', tier: 'Silver' }
      end

      it 'updates the user' do
        expect(bob.reload.role).to eq('Jungle')
        expect(bob.reload.tier).to eq('Silver')
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'redirects to the show page' do
        expect(response).to redirect_to user_path bob
      end
    end

    context 'with invalid inputs' do
      let(:bob) { Fabricate(:user) }

      before do
        set_current_user(bob)
        patch :update, id: bob.slug, user: { role: 'Jungle', tier: 'Silver', password: 'a' }
      end

      it 'assigns an instance of user' do
        expect(assigns(:user)).to be_an_instance_of(User)
      end

      it 'renders the edit page' do
        expect(response).to render_template :edit
      end
    end

    context 'for unauthorized users' do
      it 'redirects to the root path if the user is different' do
        bob = Fabricate(:user)
        set_current_user
        patch :update, id: bob.slug, user: { role: 'Jungle', tier: 'Silver' }
        expect(response).to redirect_to root_path
      end

      it 'redirects to the sign in page if the user is not signed in' do
        bob = Fabricate(:user)
        patch :update, id: bob.slug, user: { role: 'Jungle', tier: 'Silver' }
        expect(response).to redirect_to login_path
      end
    end
  end
end