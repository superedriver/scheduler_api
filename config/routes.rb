Rails.application.routes.draw do
    namespace :api do
      namespace :v1 do
        resource :users, only: [:create, :show, :update, :destroy]
        resources :events, only: [:create, :show, :update, :destroy, :index]

        post '/login' => 'sessions#create'
        delete '/logout' => 'sessions#destroy'

        post '/registration' => 'users#create'
      end
    end
end
