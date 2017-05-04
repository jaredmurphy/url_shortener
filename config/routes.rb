Rails.application.routes.draw do
  get "/:short_link", to: "urls#show"

  namespace :api do
    namespace :v1 do
      get "/tops", to: "urls#top"
      post "/urls", to: "urls#create"
    end
  end

end
