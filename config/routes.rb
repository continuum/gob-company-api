Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
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
