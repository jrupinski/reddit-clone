Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'subs#index'

  resources :users
  resources :subs
  resources :posts, except: :index do
    member do
      post 'upvote'
      post 'downvote'
    end
    resources :comments, only: :new
  end
  resources :comments, except: %i[new index] do
    member do
      post 'upvote'
      post 'downvote'
    end
  end
  resource :session, only: %i[new create destroy]
end
