Rails.application.routes.draw do

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace 'api' do
    get 'organization/public' => 'organizations#get_organization'
    post 'auth/register', to: 'authentications#register'
    post 'auth/login', to: 'authentications#login'
    get 'users/:id', to: 'users#show'
    patch 'users/:id', to: 'users#update'
    get 'users', to: 'users#index'
    get 'auth/me', to: 'users#show'
    delete 'users/:id', to: 'users#destroy'
    patch 'organization/public', to: 'organizations#update'
    get 'backoffice/contacts', to: 'contacts#index'
    get 'my_contacts', to: 'contacts#my_contacts'
    get 'news/:id/comments', to: 'news#list_comment_news'

    resources :news, only: [:show, :destroy, :create, :update, :index]
    resources :slides, only: [:index, :update, :destroy, :show, :create]
    resources :categories, only: [:index, :create, :update, :destroy, :show]
    resources :activities, only: [:index, :create, :update, :destroy]
    resources :contacts, only: [:index, :create]
    resources :testimonials, only: [:create, :update, :destroy, :index]
    resources :members, only: [:index, :destroy, :create, :update]
    resources :comments, only: [:index, :create, :update, :destroy]
    
  end

end
