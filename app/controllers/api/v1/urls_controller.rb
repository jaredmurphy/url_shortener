class Api::V1::UrlsController < ApplicationController
  def create
    new_url = Url.new(url_params)
    if new_url.save
      render json: new_url
    else
      render json: new_url.errors, status: 400
    end
  end

  def top
    render json: Url.top
  end

  private
  def url_params
    params.require(:url).permit(:full_link)
  end
end
