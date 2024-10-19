Rails.application.routes.draw do
  get 'scrapings', to: 'scrapings#index'

  get "up" => "rails/health#show", as: :rails_health_check

end
