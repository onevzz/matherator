Rails.application.routes.draw do
  devise_for :users
  resources :decks
  resources :flashcards
  #get 'home/index'
  root 'home#index'
end
