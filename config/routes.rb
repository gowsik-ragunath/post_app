Rails.application.routes.draw do
  
  devise_for :users
  resources :tags
  # resources :tag_post_members
  resources :topics do
    resources :posts do
      resources :comments    
      resources :ratings
    end
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root to: 'posts#index'
  # get '/posts/new', to: 'posts#new'
  # post '/posts', to: 'posts#create'
  # get '/posts/:id', to: 'posts#show' ,as: 'post'
  # delete '/posts/:id', to: 'posts#delete'
  # post 'posts/:id', to: 'posts#edit'
  get '/posts', to: "posts#index"
  get '/topics/:topic_id/posts/:id/status', to: "posts#read_status"
  root to:"topics#index"
end
	