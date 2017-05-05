class UrlsController < ApplicationController
  def show
    url = Url.location(params[:short_link])
    url.increment_access_count
    redirect_to url.full_link
  end
end
