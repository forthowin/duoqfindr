class SearchesController < ApplicationController
  before_action :require_user

  def show
    if params[:radius] and params[:radius].to_i >= 1 and params[:radius].to_i <= 150
      @users = current_user.nearbys(params[:radius].to_i)
    elsif params[:radius] and (params[:radius].to_i < 1 or params[:radius].to_i > 150)
      flash[:danger] = "Value must be between 1-150."
      render :show
    end
  end
end