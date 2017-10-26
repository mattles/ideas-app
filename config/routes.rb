Rails.application.routes.draw do
  resources :ideas do
    resources :comments
  end

  root to: "ideas#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
