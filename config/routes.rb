Rails.application.routes.draw do

	root 'pages#index'

	get '/signup',  to: 'users#new'
	post '/signup',  to: 'users#create'
	get '/login', to: 'sessions#new'
	post '/login', to: 'sessions#create'
	delete '/logout', to: 'sessions#destroy'
	get '/create-event',  to: 'events#new'
	post '/create-event',  to: 'events#create'
	patch '/create-event',  to: 'events#create'

	resources :users do
		member do
			get :attending
		end
	end
	resources :events do
		member do
			get :attendees
		end
	end
	resources :users, only: [:show]
	resources :events
	resources :attends, only: [:create, :destroy]
end
