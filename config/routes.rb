Rails.application.routes.draw do
  devise_for :users, skip: :all, defaults: { format: :json }, controllers: { 
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    post 'login' => 'users/sessions#create'
    post 'register' => 'users/registrations#create'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, except: [:new, :create] do #except create
    resources :collaborations
  end

  resources :projects do
    resources :collaborations
  end

  resources :badges

  post "/projects/:project_id/collaborations/:collaboration_id/increment", to: 'collaborations#increment'
  get "/users/:user_id/collaboration/:project_id", to: 'users#project_collaboration'
  get "/users/:user_id/sites_usernames", to: 'users#sites_usernames'
  post "/users/:user_id/site_username", to: 'users#site_username'
  post '/users/:user_id/join_project', to: 'users#join_project'
  #post "/projects/:project_id/owner", to: 'projects#owner'
end
