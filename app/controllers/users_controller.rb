class UsersController < ApplicationController
  before_action :require_user, only: [:edit, :update, :link_account, :token, :show, :unlink_account]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.ip_address = request.ip
    if params[:user][:terms] == '0'
      flash.now[:danger] = 'You must check the checkbox.'
      render :new
    elsif @user.save
      session[:user_id] = @user.id
      flash[:success] = 'You have successfully registered.'
      redirect_to edit_user_path @user
    else
      render :new
    end
  end

  def show
    if @user.summoner_id.present? && Rails.cache.fetch(@user.summoner_id).nil?
      league = RiotApi::League.by_summoner_entry(@user.summoner_id, @user.region)
      if league.successful?
        @user.update_column(:tier, league.data[@user.summoner_id.to_s].first['tier'])
        Rails.cache.fetch(@user.summoner_id, expires_in: 12.hours) do
          league.data[@user.summoner_id.to_s].first
        end
      end
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'Your have successfully updated your profile.'
      redirect_to edit_user_path(@user)
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
    summoner = RiotApi::Summoner.by_name(params[:summoner_name], params[:region])
    if summoner.successful?
      normalized_summoner_name = params[:summoner_name].downcase.gsub(/\s+/,"")
      summoner_id = summoner.data[normalized_summoner_name]['id']

      rune_pages = RiotApi::Summoner.runes(summoner_id, params[:region])

      if current_user.account_token == rune_pages.data[summoner_id.to_s]['pages'].first['name']
        current_user.update(summoner_id: summoner.data[normalized_summoner_name]['id'], region: params[:region])
        flash[:success] = 'Your account was linked successfully!'
        redirect_to :back
      else
        flash[:danger] = 'Token did not match or runepage has not been updated yet. Verify account again in a bit.'
        redirect_to :back
      end
    else
      flash[:danger] = summoner.error_message || rune_pages.error_message
      redirect_to :back
    end
  end

  def unlink_account
    current_user.update_column(:summoner_id, nil)
    flash[:success] = 'You have successfully unlinked your League account.'
    redirect_to edit_user_path current_user
  end
  
  private

  def set_user
    @user = User.find_by slug: params[:id]
  end

  def user_params
    params.require(:user).permit(:username, :role, :tier, :password, :email, :terms, :bio)
  end

  def require_same_user
    if current_user != @user
      flash[:danger] = "You can't do that."
      redirect_to root_path
    end
  end
end