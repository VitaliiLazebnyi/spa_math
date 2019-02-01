# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    scope module: :v1 do
      post 'login', to: 'sessions#login'
      post 'signup', to: 'sessions#signup'

      post 'calculate', to: 'calculate#calculate'
    end
  end
end
