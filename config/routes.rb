Rails.application.routes.draw do
  get 'password_reset/create'

  #welcome
  root 'pseudo_static#welcome'
  
  #signup view destroy users
  resources :users
  get 'signup'  => 'users#new'

  #login - logout
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  get 'logout'  => 'sessions#destroy' #TODO: fix; no logout through get
  delete 'logout'  => 'sessions#destroy'
  get 'resession'  => 'sessions#reset' #simulates session reset (reopening browser) (clears session cookie)
 
  #activation stuff
  post 'account_activations' => 'account_activations#create'
  post 'account_activations/:token' => 'account_activations#activate' , as: :account_activate
  get 'account_activations/:token' => 'account_activations#activate' #try to avoid use get

  #pasword reset stuff
  get 'reset_request'  => 'password_resets#new' #get reset request form
  post 'send_reset_request'  => 'password_resets#create' #sends password request and creates corresponding record in db
  get 'password_resets/:token' => 'password_resets#edit', as: :password_reset #get password reset form
  patch 'reset_password' => 'password_resets#reset' #finally changes password in user, reset record in db can be deleted

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
