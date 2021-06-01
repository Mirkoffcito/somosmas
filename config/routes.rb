Rails.application.routes.draw do
  
  namespace 'api' do
    get 'organization/public' => 'organizations#index'
    post 'auth/register', to: 'users#register'
    post 'auth/login', to: 'authentications#login'
    get 'users', to: 'users#index'
  end


  
end
