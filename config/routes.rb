Rails.application.routes.draw do
  post 'scrapings', to: 'scrapings#index'

  get "up" => "rails/health#show", as: :rails_health_check

end
