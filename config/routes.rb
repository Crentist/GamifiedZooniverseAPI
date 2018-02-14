Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    resources :collaborations
  end

  resources :projects do
    resources :collaborations
  end

  resources :badges

  post "/projects/:project_id/collaborations/:collaboration_id/increment", to: 'collaborations#increment'
  get "/users/:user_id/collaboration/:project_id", to: 'users#projectCollaboration'
  #post "/projects/:project_id/owner", to: 'projects#owner'
end
