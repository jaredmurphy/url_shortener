class UrlsController < ApplicationController 
  def show
    redirect_to Url.location(params[:short_link])
  end
end
