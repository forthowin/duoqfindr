class SearchesController < ApplicationController
  before_action :require_user

  def edit
  end

  def show
    @users = current_user.nearbys(params[:radius].to_i)
  end
end