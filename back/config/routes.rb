Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'cities', to:'cities#get'
    end
  end
end
