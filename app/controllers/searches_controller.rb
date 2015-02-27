class SearchesController < ApplicationController

  def edit
  end

  def show
    @users = current_user.nearbys(params[:radius].to_i)
  end
end