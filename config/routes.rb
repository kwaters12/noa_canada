Rails.application.routes.draw do

  mount Judge::Engine => '/judge'

  as :agent do
    match '/agent/confirmation' => 'confirmations#update', :via => :put, :as => :update_agent_confirmation
  end
  devise_for :agents, :controllers => {:registrations => 'registrations', :confirmations => 'confirmations'} do
    put "confirm_account", :to => "confirmations#confirm_account"
  end
  resources :agents do
    resources :steps, controller: 'after_signup'
  end

  root "homepage#index"

  resources :taxpayers
  resources :orders
  resources :brokerages
  resources :sub_brokerages

  resources :after_signup

  get :agent_connect, to: "agents#connect"
  get :agent_lookup, to: "agents#lookup"

  devise_scope :agent do
    put "/confirm" => "confirmations#confirm"
  end

  get '/docusign_response/:envelopeID(.:format)' => 'orders#docusign_response', as: 'docusign_response'

  post '/orders/:id' => 'orders#show'
  post '/hook' => 'orders#hook'

  get '/dropbox/authorize' => 'dropbox#authorize', as: 'dropbox_auth'
  get '/dropbox/callback' => 'dropbox#callback', as: 'dropbox_callback'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
