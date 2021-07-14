Rails.application.routes.draw do
  root 'home#index'
  get 'home/about' => 'home#about'
  get 'home/lookup' => 'home#lookup'
  post 'home/lookup' => 'home#lookup'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
