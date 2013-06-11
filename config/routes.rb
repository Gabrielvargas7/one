Mywebroom::Application.routes.draw do




  resources :locations


  resources :sections

  resources :password_resets

  resources :notifications

  resources :feedbacks

  resources :bundles_bookmarks

  resources :bookmarks

  resources :items_designs

  resources :bookmarks_categories

  resources :themes

  resources :bundles

  resources :items

  resources :users

  resources :sessions, only: [:new, :create, :destroy]


  # Link to the html. pages erb
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete


  #facebook login
  match 'auth/:provider/callback', to: 'sessions#create_facebook'
  match 'auth/failure', to: redirect('/')
  #match 'signout', to: 'sessions#destroy', as: 'signout'


  # static pages
  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'

  #main page
  match '/room/:username', to: 'rooms#room', via: :get,as: :room_rooms

  match '/bookmarks/index/bookmarks_approval', to: 'bookmarks#index_bookmarks_approval', via: :get,as: :index_bookmarks_approval
  match '/bookmarks/update/bookmarks_approval_for_a_user/:bookmark_id', to: 'bookmarks#update_bookmarks_approval_for_a_user', via: :put,as: :update_bookmarks_approval_for_a_user
  match '/bookmarks/update/bookmarks_approval_for_all_users/:bookmark_id', to: 'bookmarks#update_bookmarks_approval_for_all_users', via: :put,as: :update_bookmarks_approval_for_all_users


  root to: 'static_pages#home'

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
        'themes#json_index', via: :get, as:
        :themes_json_index

  match 'themes/json/show/:id', to:
        'themes#json_show', via: :get ,as:
        :themes_json_show


  #--------------------------
  # end Themes contract
  #--------------------------



  #**************************
  #  start Rooms contract
  #**************************
  match '/rooms/json/show_room_by_user_id/:user_id', to:
         'rooms#json_show_room_by_user_id', via: :get ,as:
         :rooms_json_show_room_by_user_id
  #--------------------------
  # end Rooms contract
  #--------------------------


  #**************************
  #  start Bundles contract
  #**************************
  match '/bundles/json/index_bundles', to:
         'bundles#json_index_bundles', via: :get , as:
         :bundles_json_index_bundles
  #--------------------------
  # end Bundles contract
  #--------------------------


  #**************************
  #  start Searches contract
  #**************************
  match '/searches/json/index_searches_user_name_by_user_id_with_limit_and_offset_and_keyword/:user_id/:limit/:offset/:keyword', to:
         'searches#json_index_searches_user_name_by_user_id_with_limit_and_offset_and_keyword', via: :get, as:
         :searches_json_index_searches_user_name_by_user_id_with_limit_and_offset_and_keyword

  #--------------------------
  # end Searches contract
  #--------------------------


  #**************************
  # start ItemsDesigns Contract
  #**************************

  match '/items_designs/json/index_items_designs_by_item_id/:item_id', to:
         'items_designs#json_index_items_designs_by_item_id', via: :get  , as:
         :items_designs_json_index_items_designs_by_item_id


  #--------------------------
  # end ItemsDesigns Contract
  #--------------------------


  #**************************
  # start Users Contract
  #**************************


  match '/users/json/update_username_by_user_id/:user_id', to:
         'users#json_update_username_by_user_id', via: :put

  match '/users/json/show_user_profile_by_user_id/:user_id', to:
         'users#json_show_user_profile_by_user_id', via: :get , as:
         :users_json_show_user_profile_by_user_id


  match '/users/json/create_user_full_bundle_by_user_id_and_bundle_id/:user_id/:bundle_id', to:
         'users#json_create_user_full_bundle_by_user_id_and_bundle_id', via: :post

  match '/users/json/update_users_image_profile_by_user_id/:user_id', to:
         'users#json_update_users_image_profile_by_user_id', via: :put


  #--------------------------
  # end Users Contract
  #--------------------------



  #**************************
  #  start UsersThemes Contract
  #**************************

  match '/users_themes/json/update_user_theme_by_user_id/:user_id', to:
         'users_themes#json_update_user_theme_by_user_id', via: :put

  match '/users_themes/json/show_user_theme_by_user_id/:user_id', to:
         'users_themes#json_show_user_theme_by_user_id', via: :get , as:
         :users_themes_json_show_user_theme_by_user_id



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
         'users_items_designs#json_index_user_items_designs_by_user_id', via: :get, as:
         :users_items_designs_json_index_user_items_designs_by_user_id


  match '/users_items_designs/json/show_user_items_design_by_user_id_and_items_design_id/:user_id/:items_design_id', to:
         'users_items_designs#json_show_user_items_design_by_user_id_and_items_design_id', via: :get, as:
         :users_items_designs_json_show_user_items_design_by_user_id_and_items_design_id



  #--------------------------
  # end UsersItemsDesign Contract
  #--------------------------


  #**************************
  # start UsersBookmarks Contract
  #**************************

    match '/users_bookmarks/json/index_user_bookmarks_by_user_id/:user_id', to:
           'users_bookmarks#json_index_user_bookmarks_by_user_id', via: :get, as:
           :users_bookmarks_json_index_user_bookmarks_by_user_id



    match '/users_bookmarks/json/index_user_bookmarks_by_user_id_and_item_id/:user_id/:item_id', to:
           'users_bookmarks#json_index_user_bookmarks_by_user_id_and_item_id', via: :get, as:
           :users_bookmarks_json_index_user_bookmarks_by_user_id_and_item_id



    match '/users_bookmarks/json/create_user_bookmark_by_user_id_and_bookmark_id_and_item_id/:user_id/:bookmark_id/:item_id', to:
           'users_bookmarks#json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id', via: :post

    match '/users_bookmarks/json/destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position/:user_id/:bookmark_id/:position', to:
           'users_bookmarks#json_destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position', via: :delete

    match '/users_bookmarks/json/create_user_bookmark_custom_by_user_id/:user_id', to:
           'users_bookmarks#json_create_user_bookmark_custom_by_user_id', via: :post




  #--------------------------
  # end UsersBookmark Contract
  #--------------------------


  #**************************
  # start BookmarksCategory Contract
  #**************************

  match 'bookmarks_categories/json/index_bookmarks_categories_with_bookmarks_by_item_id/:item_id', to:
        'bookmarks_categories#json_index_bookmarks_categories_with_bookmarks_by_item_id', via: :get, as:
        :bookmarks_categories_json_index_bookmarks_categories_with_bookmarks_by_item_id

  match 'bookmarks_categories/json/index_bookmarks_categories_with_bookmarks_been_approved_by_user_id_and_by_item_id/:user_id/:item_id', to:
        'bookmarks_categories#json_index_bookmarks_categories_with_bookmarks_been_approved_by_user_id_and_by_item_id', via: :get, as:
            :bookmarks_categories_json_index_bookmarks_categories_with_bookmarks_been_approved_by_user_id_and_by_item_id


  #**************************
  # end BookmarksCategory Contract
  #**************************


  #**************************
  # start FriendRequest Contract
  #**************************

  match '/friend_requests/json/create_friend_request_by_user_id_and_user_id_requested/:user_id/:user_id_requested', to:
         'friend_requests#json_create_friend_request_by_user_id_and_user_id_requested', via: :post

  match '/friend_requests/json/destroy_friend_request_by_user_id_and_user_id_requested/:user_id/:user_id_requested', to:
         'friend_requests#json_destroy_friend_request_by_user_id_and_user_id_requested', via: :delete

  match '/friend_requests/json/index_friend_request_make_from_your_friend_to_you_by_user_id/:user_id', to:
         'friend_requests#json_index_friend_request_make_from_your_friend_to_you_by_user_id', via: :get, as:
         :friend_requests_json_index_friend_request_make_from_your_friend_to_you_by_user_id



  #json_index_friend_request_make_from_your_friend_to_you_by_user_id
  #**************************
  # end FriendRequest Contract
  #**************************



  #**************************
  # start Friend Contract
  #**************************

  match '/friends/json/destroy_friend_by_user_id_and_user_id_friend/:user_id/:user_id_friend', to:
         'friends#json_destroy_friend_by_user_id_and_user_id_friend', via: :delete

  match '/friends/json/create_friend_by_user_id_accept_and_user_id_request/:user_id_accept/:user_id_request', to:
         'friends#json_create_friend_by_user_id_accept_and_user_id_request', via: :post


  match '/friends/json/index_friend_by_user_id/:user_id', to:
         'friends#json_index_friend_by_user_id', via: :get, as:
         :friends_json_index_friend_by_user_id



  match '/friends/json/index_friend_by_user_id_by_limit_by_offset/:user_id/:limit/:offset', to:
         'friends#json_index_friend_by_user_id_by_limit_by_offset', via: :get, as:
         :friends_json_index_friend_by_user_id_by_limit_by_offset


  match '/friends/json/index_friends_suggestion_by_user_id_by_limit_by_offset/:user_id/:limit/:offset', to:
         'friends#json_index_friends_suggestion_by_user_id_by_limit_by_offset', via: :get, as:
         :friends_json_index_friends_suggestion_by_user_id_by_limit_by_offset


  #**************************
  # end Friend Contract
  #**************************




  #**************************
  # start UsersGallery Contract
  #**************************

  match '/users_galleries/json/create_users_gallery_by_user_id/:user_id', to:
         'users_galleries#json_create_users_gallery_by_user_id', via: :post

  #**************************
  # end UsersGallery Contract
  #**************************


  #**************************
  # start Feedback Contract
  #**************************

  match '/feedbacks/json/create_feedback', to:
         'feedbacks#json_create_feedback', via: :post

  #**************************
  # end Feedback Contract
  #**************************

  #**************************
  # start user notification Contract
  #**************************

  match '/users_notifications/json/show_user_notification_by_user/:user_id', to:
         'users_notifications#json_show_user_notification_by_user', via: :get, as:
         :users_notifications_json_show_user_notification_by_user


  match '/users_notifications/json/update_user_notification_to_notified_by_user/:user_id', to:
         'users_notifications#json_update_user_notification_to_notified_by_user', via: :put

  #**************************
  # end user notification Contract
  #**************************







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
