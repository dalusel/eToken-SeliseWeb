Rails.application.routes.draw do
  get 'e_token/new'
  resources :e_token
  root :to=>'e_token#new'
  match '/e_token' => 'e_token#create' , via: :Patch
end
