Rails.application.routes.draw do
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create, :update, :destroy]
      resources :races, only: [:index, :show, :create, :update, :destroy] do
        resources :subraces, only: [:index, :show, :create, :update, :destroy]
      end
      resources :character_classes, only: [:index, :show, :create, :update, :destroy] do
        resources :subclasses, only: [:index, :show, :create, :update, :destroy]
      end
      resources :characters, only: [:index, :show, :create, :update, :destroy] do
        resources :ability_scores, only: [:index, :show, :create, :update, :destroy]
        resources :character_items, only: [:index, :create, :destroy]
        resources :character_abilities, only: [:index, :create, :destroy]
      end
      resources :items, only: [:index, :show, :create, :update, :destroy]
      resources :abilities, only: [:index, :show, :create, :update, :destroy]

      resources :battles, only: [:index, :show, :create, :update, :destroy] do
        member do
          post :start
          post :advance_turn
        end
        resources :participants, only: [:index, :show, :create, :update, :destroy] do
          member do
            get :abilities
            post :use_ability
            post :attack
            post :move
            post :end_turn
          end
        end
      end

      resources :battle_participant_selections, only: [:create, :destroy]
      resources :battle_boards, only: [:index, :show, :create, :update, :destroy]
    end
  end

  # Root level routes for backward compatibility (if needed)
  resources :users, only: [:index, :show, :create, :update, :destroy]
  resources :races, only: [:index, :show, :create, :update, :destroy]
  resources :subraces, only: [:index, :show, :create, :update, :destroy]
  resources :character_classes, only: [:index, :show, :create, :update, :destroy]
  resources :subclasses, only: [:index, :show, :create, :update, :destroy]
  resources :characters, only: [:index, :show, :create, :update, :destroy]
  resources :ability_scores, only: [:index, :show, :create, :update, :destroy]
  resources :items, only: [:index, :show, :create, :update, :destroy]
end
