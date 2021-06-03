Rails.application.routes.draw do
  
  namespace 'api' do
    get 'organization/public' => 'organizations#index'
    post 'auth/register', to: 'users#register'
    post 'auth/login', to: 'authentications#login'
    get 'auth/me', to: 'users#show'
    get 'users', to: 'users#index'
    delete 'users/:id', to: 'users#destroy'
    patch 'organization/public', to: 'organizations#update'
    get 'categories', to: 'categories#index'
  end
  
end
