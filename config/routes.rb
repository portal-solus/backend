# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/disciplines', to: 'discipline#index'
  get   '/companies', to: 'company#index'
  patch '/companies', to: 'company_updates#create'
  post '/conexao', to: 'conexoes#create'
end
