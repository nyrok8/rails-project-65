# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: 'web' do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'logout', to: 'auth#destroy', as: :logout

    root 'bulletins#index'

    resource :profile, only: :show
    resources :bulletins, except: :delete do
      member do
        patch :to_moderate
        patch :archive
      end
    end

    namespace :admin do
      root 'bulletins#under_moderation'
      resources :bulletins do
        member do
          patch :reject
          patch :publish
          patch :archive
        end
      end
      resources :categories, except: :show
    end
  end
end
