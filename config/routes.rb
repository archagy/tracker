Tracker::Application.routes.draw do

  devise_for :users
  root 'home#index'

  namespace :api, :defaults => { :format => :json} do
    namespace :v1 do
      devise_scope :user do
        resource :session, only: [:create, :destroy]
      end
      resources :clients, only: [:index, :create, :update, :destroy, :show] do
        resources :reminders, only: [:index, :create, :update, :destroy]
      end
    end
  end

  #angular
  get '/dashboard' => 'templates#index'
  get '/clients/:id' => 'templates#index'
  get '/templates/:path.html' => 'templates#template', :constraints => { :path => /.+/  }
end
