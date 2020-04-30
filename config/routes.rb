Rails.application.routes.draw do
  get 'welcome/index'
  
  root 'welcome#index'
  resources :users
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # match ':controller(/:action(/:id))(.:format)'
  resources :articles do
    resources :comments
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
