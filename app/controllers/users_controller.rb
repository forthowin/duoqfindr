class UsersController < ApplicationController
  before_action :require_user, only: [:edit, :update, :link_account, :token]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.ip_address = request.ip
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = 'You have successfully registered.'
      redirect_to edit_user_path @user
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'Your have successfully updated your profile.'
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def token
    current_user.generate_token!

    respond_to do |format|
      format.js
    end
  end

  def link_account
    begin
      account_response = JSON.parse(open("https://na.api.pvp.net/api/lol/#{params[:region]}/v1.4/summoner/by-name/#{params[:summoner_name]}?api_key=#{ENV['RIOT_API_KEY']}").read)
      summoner_id = account_response[params[:summoner_name]]['id']

      runes_response = JSON.parse(open("https://na.api.pvp.net/api/lol/na/v1.4/summoner/#{summoner_id}/runes?api_key=#{ENV['RIOT_API_KEY']}").read)

      if current_user.account_token == runes_response[summoner_id.to_s]['pages'].first['name']
        current_user.update_column(:summoner_id, account_response[params[:summoner_name]]['id'])
        flash[:success] = 'Your account was linked successfully!'
      else
        flash[:danger] = 'Token did not match or runepage has not been updated yet. Verify account again in a bit.'
      end
    rescue OpenURI::HTTPError => e
      flash[:danger] = e.message
    end
    redirect_to :back
  end

  private

  def set_user
    @user = User.find_by slug: params[:id]
  end

  def user_params
    params.require(:user).permit(:username, :role, :tier, :password)
  end

  def require_same_user
    if current_user != @user
      flash[:danger] = "You can't do that."
      redirect_to root_path
    end
  end
end