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

    resources :news, only: [:show, :destroy, :create, :update]
    resources :slides, only: [:index, :update, :destroy, :show, :create]
    resources :categories, only: [:index, :create, :update, :destroy, :show]
    resources :activities, only: [:index, :create, :update, :destroy]
    resources :contacts, only: [:index, :create]
    resources :testimonials, only: [:create, :update, :destroy, :index]
    resources :members, only: [:index, :destroy, :create, :update]
    resources :comments, only: [:index, :create, :update]
    
  end

end
