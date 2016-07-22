Rails.application.routes.draw do
  constraints subdomain: 'api' do
    scope module: 'api' do
      namespace :v1 do
        resources :users do
          resources :events
        end
      end
    end
  end
 # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
