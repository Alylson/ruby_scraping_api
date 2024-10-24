Rails.application.routes.draw do
  #post 'scrapings', to: 'scrapings#index'
  resources :scrapings, only: %i[index create show update destroy]
  root "scrapings#index"

  get "up" => "rails/health#show", as: :rails_health_check

end
