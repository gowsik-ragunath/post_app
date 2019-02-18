Rails.application.routes.draw do
  root to:"topics#index"
  devise_for :users , controllers: {
      registrations: 'users/registrations'
  }

  resources :tags
  resource :authentications, only: [:authenticate],path: '' do
    collection do
      post :authenticate, path: '/user'
    end
  end
  resource :devices, only: [:device_detect],path: '' do
    collection do
      get :device_detect, path: '/device'
    end
  end
  resources :topics do
    collection do
      get :index , controller: :posts , path: '/posts' , as: 'posts'
    end
    resources :posts do
      member do
        post :status
      end
      resources :comments do
        member do
          post :rate_comment
          get :show_comment
        end
      end
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
  # get '/device', to: "application#device_detect"
  # post '/user', to: "application#authenticate"
  # get '/posts', to: "posts#index", as: 'posts'
  # get '/posts/show_details', to: "posts#show_details", as: 'posts_show_details'
  # get '/topics/:topic_id/posts/:id/status', to: "posts#read_status"
  # post '/topics/:topic_id/posts/:id/rate_comment', to: "posts#rate_comment" ,as: 'post_rate_comment'
  # get '/topics/:topic_id/posts/:id/show_comment', to: "posts#show_comment" ,as: 'post_show_comment'
end
	