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
    if @user.summoner_id.present?
      if Rails.cache.fetch(@user.summoner_id).nil?
        begin
          result = JSON.parse(open("https://#{@user.region}.api.pvp.net/api/lol/#{@user.region}/v2.5/league/by-summoner/#{@user.summoner_id}/entry?api_key=#{ENV['RIOT_API_KEY']}").read)
          Rails.cache.fetch(@user.summoner_id, expires_in: 12.hours) do
            result[@user.summoner_id.to_s].first
          end
        rescue OpenURI::HTTPError => e
          flash[:danger] = e.message
          redirect_to search_path
        end
      end
    end
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
      account_response = JSON.parse(open(URI.escape("https://#{params[:region]}.api.pvp.net/api/lol/#{params[:region]}/v1.4/summoner/by-name/#{params[:summoner_name]}?api_key=#{ENV['RIOT_API_KEY']}")).read)
      normalized_summoner_name = params[:summoner_name].downcase.gsub(/\s+/,"")
      summoner_id = account_response[normalized_summoner_name]['id']

      runes_response = JSON.parse(open("https://#{params[:region]}.api.pvp.net/api/lol/#{params[:region]}/v1.4/summoner/#{summoner_id}/runes?api_key=#{ENV['RIOT_API_KEY']}").read)

      if current_user.account_token == runes_response[summoner_id.to_s]['pages'].first['name']
        current_user.update(summoner_id: account_response[params[:summoner_name]]['id'], region: params[:region])
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