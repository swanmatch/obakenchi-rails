Rails.application.routes.draw do
  resources :discovers do
      collection do
        match 'search', action: :index, as: :search, via: [:get, :post]
      end
    end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
