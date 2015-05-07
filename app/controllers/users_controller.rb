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
    if @user.summoner_id.present? && Rails.cache.fetch(@user.summoner_id).nil?
      summoner_data = RiotApi::League.by_summoner_entry(@user.summoner_id, @user.region)
      if summoner_data.successful?
        Rails.cache.fetch(@user.summoner_id, expires_in: 12.hours) do
          summoner_data.response[@user.summoner_id.to_s].first
        end
      else
        flash[:danger] = summoner_data.error_message
        redirect_to search_path
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
    summoner_data = RiotApi::Summoner.by_name(params[:summoner_name], params[:region])
    if summoner_data.successful?
      normalized_summoner_name = params[:summoner_name].downcase.gsub(/\s+/,"")
      summoner_id = summoner_data.response[normalized_summoner_name]['id']

      runes_pages = RiotApi::Summoner.runes(summoner_id, params[:region])

      if current_user.account_token == runes_pages.response[summoner_id.to_s]['pages'].first['name']
        current_user.update(summoner_id: summoner_data.response[params[:summoner_name]]['id'], region: params[:region])
        flash[:success] = 'Your account was linked successfully!'
      else
        flash[:danger] = 'Token did not match or runepage has not been updated yet. Verify account again in a bit.'
      end
    else
      flash[:danger] = summoner_data.error_message || runes_pages.error_message
    end
    redirect_to :back
  end

  private

  def set_user
    @user = User.find_by slug: params[:id]
  end

  def user_params
    params.require(:user).permit(:username, :role, :tier, :password, :email)
  end

  def require_same_user
    if current_user != @user
      flash[:danger] = "You can't do that."
      redirect_to root_path
    end
  end
end