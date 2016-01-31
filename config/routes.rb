Rails.application.routes.draw do
  # Listing of all available projects

  resources :projects, only: :index do
    collection do
      get :mine
    end
  end

  resources :project, constraints: {format: :json} do
    member do
      # Allows a user to add or remove
      # their vote
      put 'vote'
      put 'unvote'
    end
  end

  resources :users

  # By default we want to show all the available projects
  root 'projects#index'
end
