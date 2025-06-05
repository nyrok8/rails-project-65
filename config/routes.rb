# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: 'web' do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'logout', to: 'auth#destroy', as: :logout

    root 'bulletins#index'
    resources :bulletins do
      member do
        patch :to_moderate
        patch :reject
        patch :publish
        patch :archive
      end
    end

    get 'profile', to: 'profile#index'

    namespace :admin do
      root 'home#index'
      resources :bulletins
      resources :categories, except: :show
    end
  end
end
