Rails.application.routes.draw do
  resources :sessions, only: [:create]
  resources :jobs, only: [] do
    collection do 
      get 'active'
      get 'closed'      
    end

    member do
      get '/processes/:id', to: 'jobs#show'
    end
  end
end
