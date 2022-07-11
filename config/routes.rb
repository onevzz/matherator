Rails.application.routes.draw do
  resources :decks
  resources :flashcards
  #get 'home/index'
  root 'home#index'
end
