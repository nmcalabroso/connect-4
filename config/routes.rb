Rails.application.routes.draw do
  root 'static_pages#home'
  resources :game_rooms do
    member do
      patch :join
      resource :game_board, only: [ :update ]
    end
  end
end
