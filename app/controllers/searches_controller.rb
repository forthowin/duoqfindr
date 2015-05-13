class SearchesController < ApplicationController
  MIN_RADIUS = 10
  MAX_RADIUS = 150

  before_action :require_user

  def show
    if params[:radius].to_i.between?(MIN_RADIUS, MAX_RADIUS)
      @users = current_user.nearbys(params[:radius].to_i).paginate(:page => params[:page])
      flash.now[:info] = 'No match found. Try again later when more players sign up.' unless @users.present?
    elsif params[:radius].present?
      flash.now[:danger] = "Value must be between #{MIN_RADIUS} and #{MAX_RADIUS}."
    end
    render :show
  end
end