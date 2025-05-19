Rails.application.routes.draw do
  root to: 'books#index'

  devise_for :users
  resources :users, only: %i[index show]

  resources :books do
    resources :comments, only: %i[create edit update destroy], shallow: true
  end

  resources :reports do
    resources :comments, only: %i[create edit update destroy], shallow: true
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
