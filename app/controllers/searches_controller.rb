class SearchesController < ApplicationController
  MIN_RADIUS = 1
  MAX_RADIUS = 150

  before_action :require_user

  def show
  end

  def update
    if params[:radius].to_i.between?(MIN_RADIUS, MAX_RADIUS)
      @users = current_user.nearbys(params[:radius].to_i)
    else
      flash.now[:danger] = "Value must be between 1-150."
    end
    render :show
  end
end