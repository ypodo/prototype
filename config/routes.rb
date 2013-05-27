Prototype::Application.routes.draw do
  
  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  resources :invites, :only => [:create, :destroy]
  resources :rescues
  
  match '/history/show' => 'history#show'
  match '/users/:id/start' => 'calls#start'
  match '/users/:id/can_start' => 'calls#can_start'
  
  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/upload', :to => 'upload#upload'
  #AJAX
  match '/invites/delete_all', :to => 'invites#delete_all'  
  match '/ajax_report_mail', :to => 'users#ajax_report_mail_to'  
  match '/users/:id/ajax_progress_call' => 'users#ajax_progress_call'
  match '/users/:id/ajax_report' => 'users#ajax_report'
  match '/users/:id/ajax_report_sum' => 'users#ajax_report_sum'
  match '/history/show/:id' => 'history#ajax_history_invites_by_token'
  match '/users/:id/ajax_payment_details' => 'users#ajax_payment_details'
  #Post recorder
  match '/post.php', :to => 'users#recorder'
  #match '/full_report/ajax_progress_call' => 'users#ajax_progress_call'
  #match '/full_report/ajax_report' => 'users#ajax_report'
  #static pages
  match '/partners', :to => 'pages#partners'
  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'
  match '/support', :to => 'pages#support'
  match '/term_of_use', :to => 'pages#term_of_use'
  match '/foo', :to => 'pages#foo'
  
  # Cotial Auth routing  
  match 'auth/provider/callback', :to => 'sessions#create'
  match 'auth/failure', :to => redirect('/')
  match 'signout', :to => 'sessions#destroy', as: 'signout'
  #paypal-express
  match '/orders/checkout', :to => 'orders#checkout'
  match '/orders/new', :to => 'orders#new'
  match '/orders/cancel', :to => 'orders#cancel'
  match '/orders/confirm', :to => 'orders#confirm'
  
  root :to => 'pages#home'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
