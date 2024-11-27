Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :batches, only: [:show, :edit, :destroy] do
    resources :messages, only: :create
  end
  authenticate :user, ->(u) { u.admin? } do
    mount MissionControl::Jobs::Engine, at: "/jobs"
  end
end
