Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'user_auth', controllers: {
        registrations: 'api/v1/registrations'
        # コントローラーの参照先を設定
    }
      mount_devise_token_auth_for 'Admin', at: 'admin_auth', controllers: {
        registrations: 'api/v1/registrations'
        # コントローラーの参照先を設定
    }
      get 'cities', to:'cities#get'
      get ':prefecture_id/cities', to:'cities#get'
      get ':area_id/:prefecture_id/cities', to:'cities#get'
      resources :offices
      resources :bookmarks, only: [:create, :destroy, :index]
    end
  end
end

