Rails.application.routes.draw do
  
  namespace 'api' do
    get 'organization/public' => 'organizations#index'
    post 'auth/register', to: 'authentications#register'
    post 'auth/login', to: 'authentications#login'
    get 'auth/me', to: 'users#show'
    patch 'users/:id', to: 'users#update'
    get 'users', to: 'users#index'
    delete 'users/:id', to: 'users#destroy'
    patch 'organization/public', to: 'organizations#update'

    resources :news, only: [:show, :destroy, :create]
    resources :slides, only: [:index]
    resources :categories, only: [:index, :create, :destroy, :show]
    resources :activities, only: [:create, :update]
  end
  
end
