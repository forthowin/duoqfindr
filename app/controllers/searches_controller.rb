class SearchesController < ApplicationController
  MIN_RADIUS = 1
  MAX_RADIUS = 150

  before_action :require_user

  def show
  end

  def update
    if params[:radius] and params[:radius].to_i >= MIN_RADIUS and params[:radius].to_i <= MAX_RADIUS
      @users = current_user.nearbys(params[:radius].to_i)
      render :show
    elsif params[:radius] and (params[:radius].to_i < MIN_RADIUS or params[:radius].to_i > MAX_RADIUS)
      flash.now[:danger] = "Value must be between 1-150."
      render :show
    end
  end
end