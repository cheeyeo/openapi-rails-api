Rails.application.routes.draw do
  use_doorkeeper do
    controllers tokens: 'custom_tokens',
                authorizations: 'custom_authorizations'
  end

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :todos
    end
  end
end
