Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root to: 'posts#index'
  # get '/posts/new', to: 'posts#new'
  # post '/posts', to: 'posts#create'
  # get '/posts/:id', to: 'posts#show' ,as: 'post'
  # delete '/posts/:id', to: 'posts#delete'
  # post 'posts/:id', to: 'posts#edit'
  resources :posts
end
	