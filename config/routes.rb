Rails.application.routes.draw do
  resources :items
  resources :ability_scores
  resources :subclasses
  resources :character_classes
  resources :subraces
  resources :races
  resources :characters
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  #
  namespace :api do
    namespace :api do
      resources :characters, only: [ :index, :show, :create, :update, :destroy ]
    end

    resources :battles, only: [ :show ] do
      member do
        post :advance_turn
      end

      resources :participants, only: [] do
        member do
          get :abilities
          post :use_ability
        end
      end
    end
  end
end
