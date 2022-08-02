Rails.application.routes.draw do
  devise_for :users
  resources :decks
  resources :flashcards
  root 'home#index'
  get 'download' => 'decks#download'
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
end
