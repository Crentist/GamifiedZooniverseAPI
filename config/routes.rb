Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    resources :collaborations
  end
  resources :projects do
    resources :collaborations
  end

  post "/projects/:project_id/collaborations/:collaboration_id/increment", to: 'collaborations#increment'
  #post "/projects/:project_id/owner", to: 'projects#owner'
end
