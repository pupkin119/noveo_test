Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  resources :questionnaire,only: [:create, :new, :show, :index], controller: 'questionnaire'
end
