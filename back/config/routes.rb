Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'cities', to:'cities#get'
      get ':prefecture_id/cities', to:'cities#get'
      get ':area_id/:prefecture_id/cities', to:'cities#get'
      resources :offices, only:[:index,:show,:edit,:destroy]
    end
  end
end

