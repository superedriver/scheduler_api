Rails.application.routes.draw do
    scope module: 'api' do
      namespace :v1 do
        resource :users, only: [:create, :show, :update, :destroy]
        resources :events, only: [:create, :show, :update, :destroy, :index]

        post '/login' => 'sessions#create'

        post '/registration' => 'users#create'
      end
    end
end
