SampleApp::Application.routes.draw do


  resources :bundles_bookmarks


  resources :bookmarks


  resources :items_designs


  resources :bookmarks_categories


  resources :themes


  resources :bundles


  resources :items


  root to: 'static_pages#home'


  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'

  #get "users/new"

  # Link to the controller
  #match '/user/:email' =>  'user#show'
  #match '/rooms/:email' =>  'users#showrooms'
  #match '/rooms/:id' =>  'users#rooms'



  #match '/room/:id', to: 'rooms#show'

  ##
  ## /folder name/controller name/<action>/method name/...
  #match '/rest/rooms/get/room/:id', to:'rest::rooms#get_room' , via: :get
  #match '/rest/rooms/post/room/:id', to:'rest::rooms#get_room' , via: :post
  #match '/rest/rooms/put/room/:id', to:'rest::rooms#get_room' , via: :put
  #match '/rest/rooms/delete/room/:id', to:'rest::rooms#get_room' , via: :delete


  #resources :rooms
  #match '/room/:username' =>  'users#room'
  #resources :rooms, :path => "/rest/rooms"

  #match '/rest/rooms/:id', to:'rest::rooms#show'

  #namespace :rest do
  #  # Directs /admin/products/* to Admin::ProductsController
  #  # (app/controllers/admin/products_controller.rb)
  #  resources :rooms   do
  #    member do
  #      get :get_room
  #      put :put_create
  #    end
  #  end
  #end



  resources :rooms
  resources :users
  resources :sessions, only: [:new, :create, :destroy]



  # Link to the html. pages erb
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/:username', to: 'users#room', via: :get



  #get "static_pages/home"
  #get "static_pages/about"
  #get "static_pages/help"
  #get "static_pages/contact"





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

  ## Sample resource route within a namespace:
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
  # match ':controller(/:action(/:id))(.:format)'


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
  # match ':controller(/:action(/:id))(.:format)'
end
