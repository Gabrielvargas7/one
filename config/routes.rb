SampleApp::Application.routes.draw do


  resources :bundles_bookmarks

  resources :bookmarks

  resources :items_designs

  resources :bookmarks_categories

  resources :themes

  resources :bundles

  resources :items

  root to: 'static_pages#home'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]


  # Link to the html. pages erb
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete


  # static pages
  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'

  #main page
  match '/room/:username', to: 'rooms#room', via: :get



# Contract Back-end -- Front-end only Json responce
# Rules of name
# 1.- name of the path should start with name of the controller , eg - for RoomsController -- should be /rooms/...
# 2.- name of the method should start with the (rials rule action for REST)
    # eg - for GET -- should be -- show (for one),
    # eg - for GET -- should be -- index (for all)
    # eg - for PUT -- should be -- update
    # eg - for DELETE -- should be -- destroy
    # eg - for POST -- should be -- create
# 3.- following with the specific action and how you going to find it  eg room_by_user_id/:user_id
# eg if you want all the items of the room the path should be
#  /rooms/show_room_by_user_id/:user_id


 #**************************
 #  Start Themes contract
 #**************************

  match 'themes/json/index', to:
        'themes#json_index', via: :get

  match 'themes/json/show/:id', to:
        'themes#json_show', via: :get


  #--------------------------
  # end Themes contract
  #--------------------------



  #**************************
  #  start Rooms contract
  #**************************
  match '/rooms/json/show_room_by_user_id/:user_id', to:
         'rooms#json_show_room_by_user_id', via: :get

  #--------------------------
  # end Rooms contract
  #--------------------------



  #**************************
  # start ItemsDesigns Contract
  #**************************

  match '/items_designs/json/index_items_designs_by_item_id/:item_id', to:
         'items_designs#json_index_items_designs_by_item_id', via: :get

  #--------------------------
  # end ItemsDesigns Contract
  #--------------------------


  #**************************
  # start Users Contract
  #**************************


  match '/users/json/update_username_by_user_id/:user_id', to:
         'users#json_update_username_by_user_id', via: :put

  #--------------------------
  # end Users Contract
  #--------------------------



  #**************************
  #  start UsersThemes Contract
  #**************************

  match '/users_themes/json/update_user_theme_by_user_id/:user_id', to:
         'users_themes#json_update_user_theme_by_user_id', via: :put

  match '/users_themes/json/show_user_theme_by_user_id/:user_id', to:
         'users_themes#json_show_user_theme_by_user_id', via: :get


  #--------------------------
  #  end UsersThemes Contract
  #--------------------------

  #**************************
  # start UsersItemsDesign Contract
  #**************************


  match '/users_items_designs/json/update_user_items_design_by_user_id_and_items_design_id/:user_id/:items_design_id', to:
         'users_items_designs#json_update_user_items_design_by_user_id_and_items_design_id', via: :put


  match '/users_items_designs/json/update_hide_user_items_design_by_user_id_and_items_design_id/:user_id/:items_design_id', to:
         'users_items_designs#json_update_hide_user_items_design_by_user_id_and_items_design_id', via: :put

  match '/users_items_designs/json/index_user_items_designs_by_user_id/:user_id', to:
         'users_items_designs#json_index_user_items_designs_by_user_id', via: :get

  match '/users_items_designs/json/show_user_items_design_by_user_id_and_items_design_id/:user_id/:items_design_id', to:
         'users_items_designs#json_show_user_items_design_by_user_id_and_items_design_id', via: :get


  #--------------------------
  # end UsersItemsDesign Contract
  #--------------------------


  #**************************
  # start UsersBookmarks Contract
  #**************************

    match '/users_bookmarks/json/index_user_bookmarks_by_user_id/:user_id', to:
           'users_bookmarks#json_index_user_bookmarks_by_user_id', via: :get

    match '/users_bookmarks/json/index_user_bookmarks_by_user_id_and_item_id/:user_id/:item_id', to:
           'users_bookmarks#json_index_user_bookmarks_by_user_id_and_item_id', via: :get


    match '/users_bookmarks/json/create_user_bookmark_by_user_id_and_bookmark_id_and_item_id/:user_id/:bookmark_id/:item_id', to:
           'users_bookmarks#json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id', via: :post

    match '/users_bookmarks/json/destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position/:user_id/:bookmark_id/:position', to:
           'users_bookmarks#json_destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position', via: :delete


  #--------------------------
  # end UsersBookmark Contract
  #--------------------------





  #get "users/new"

  # Link to the controller
  #match '/user/:email' =>  'user#show'
  #match '/rooms/:email' =>  'users#showrooms'
  #match '/rooms/:id' =>  'users#rooms'



  #match '/room/:id', to: 'rooms#show'

  ##
  ## /folder name/controller name/<action>/method name/...
  #match '/json/rooms/get/room/:id', to:'json::rooms#get_room' , via: :get
  #match '/json/rooms/post/room/:id', to:'json::rooms#get_room' , via: :post
  #match '/json/rooms/put/room/:id', to:'json::rooms#get_room' , via: :put
  #match '/json/rooms/delete/room/:id', to:'json::rooms#get_room' , via: :delete


  #resources :rooms
  #match '/room/:username' =>  'users#room'
  #resources :rooms, :path => "/json/rooms"

  #match '/json/rooms/:id', to:'json::rooms#show'

  #namespace :json do
  #  # Directs /admin/products/* to Admin::ProductsController
  #  # (app/controllers/admin/products_controller.rb)
  #  resources :rooms   do
  #    member do
  #      get :get_room
  #      put :put_create
  #    end
  #  end
  #end


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
