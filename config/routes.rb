Rails.application.routes.draw do
  root 'columns#index'
  resources :columns, only: [:index]
  resources :tasks, only: [:new, :create, :update]
end
