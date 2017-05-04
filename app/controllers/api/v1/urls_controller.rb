class Api::V1::UrlsController < ApplicationController
  def create
    new_url = Url.new(url_params)
    if new_url.save
      render json: new_url
    else
      if new_url.errors.messages[:full_link] == ["has already been taken"]
        url = Url.find_by(url_params)
        render json: url
      else
        render json: new_url.errors, status: 400
      end
    end
  end

  def top
    top_urls = Url.top
    render json: top_urls
  end

  private
  def url_params
    #ActiveModelSerializers::Deserialization.jsonapi_parse!(params, only: [:full_link] )
    params.require(:url).permit(:full_link)
  end
end
