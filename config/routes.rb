Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :batches, only: [:show, :edit, :destroy] do
    resources :messages, only: :create
  end
end
