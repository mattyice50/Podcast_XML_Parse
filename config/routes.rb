Rails.application.routes.draw do

  devise_for :users
  root to: "static_pages#home"
  resources :items do
    collection { post :import }
    collection { get :add_item }
  end

end
