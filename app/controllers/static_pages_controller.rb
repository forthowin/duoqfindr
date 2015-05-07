class StaticPagesController < ApplicationController
  def home
    if current_user
      redirect_to search_path
    end
  end
end