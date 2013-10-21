Mywebroom::Application.routes.draw do



  #resources :shop

  match '/shop/items-design/:items_design_id/:name', to:
         'shop#show_items_design', via: :get,as: :shop_show_items_design

  match '/shop', to:
         'shop#index', via: :get,as: :shop_index

  match '/shop/item/:item_id/:name', to:
         'shop#show_item', via: :get,as: :shop_show_item

  match '/shop/themes', to:
         'shop#index_themes', via: :get,as: :shop_index_themes

  match '/shop/themes/:id/:name', to:
         'shop#show_theme', via: :get,as: :shop_show_theme

  match '/shop/bundles', to:
         'shop#index_bundles', via: :get,as: :shop_index_bundles

  match '/shop/bundle/:id/:name', to:
         'shop#show_bundle', via: :get,as: :shop_show_bundle

  match '/shop/entire_rooms', to:
        'shop#index_entire_rooms', via: :get,as: :shop_index_entire_rooms

  match '/shop/entire_room/:id/:name', to:
        'shop#show_entire_room', via: :get,as: :shop_show_entire_room

  match '/shop/bookmarks', to:
         'shop#index_bookmarks', via: :get,as: :shop_index_bookmarks

  match '/shop/bookmark/:id/:name', to:
      'shop#show_bookmark', via: :get,as: :shop_show_bookmark


  resources :users_profiles

  match '/users_profiles/show_users_profiles_by_user_id/:id', to:
         'users_profiles#show_users_profiles_by_user_id', via: :get,as: :show_users_profiles_by_user_id

  match '/users_profiles/edit_users_profiles_by_user_id/:id', to:
         'users_profiles#edit_users_profiles_by_user_id', via: :get,as: :edit_users_profiles_by_user_id

  match '/users_profiles/update_users_profiles_by_user_id/:id', to:
         'users_profiles#update_users_profiles_by_user_id', via: :put,as: :update_users_profiles_by_user_id



  resources :users_photos

  match '/users_photos/index_users_photos_by_user_id/:user_id', to:
         'users_photos#index_users_photos_by_user_id', via: :get,as: :index_users_photos_by_user_id

  match '/users_photos/update_users_photos_profile_image_by_user_id_by_users_photo_id/:user_id/:users_photo_id', to:
         'users_photos#update_users_photos_profile_image_by_user_id_by_users_photo_id', via: :put,as: :update_users_photos_profile_image_by_user_id_by_users_photo_id

  match '/users_photos/new_users_photos_by_user_id/:user_id', to:
         'users_photos#new_users_photos_by_user_id', via: :get,as: :new_users_photos_by_user_id

  match '/users_photos/create_users_photos_by_user_id/:user_id', to:
         'users_photos#create_users_photos_by_user_id', via: :post,as: :create_users_photos_by_user_id

  match '/users_photos/destroy_users_photos_by_user_id_by_users_photo_id/:user_id/:users_photo_id', to:
         'users_photos#destroy_users_photos_by_user_id_by_users_photo_id', via: :delete,as: :destroy_users_photos_by_user_id_by_users_photo_id

  match '/users_photos/edit_users_photos_by_user_id_by_users_photo_id/:user_id/:users_photo_id', to:
         'users_photos#edit_users_photos_by_user_id_by_users_photo_id', via: :get,as: :edit_users_photos_by_user_id_by_users_photo_id

  match '/users_photos/update_users_photos_by_user_id_by_users_photo_id/:user_id/:users_photo_id', to:
         'users_photos#update_users_photos_by_user_id_by_users_photo_id', via: :put,as: :update_users_photos_by_user_id_by_users_photo_id





  resources :bundles_items_designs

  match '/bundles_items_designs/index/bundle_selection', to:
         'bundles_items_designs#index_bundle_selection', via: :get,as: :index_bundle_selection

  match '/bundles_items_designs/index/items_location_selection/:bundle_id/:section_id', to:
         'bundles_items_designs#index_items_location_selection', via: :get,as: :index_items_location_selection

  match '/bundles_items_designs/index/items_design_selection/:bundle_id/:location_id/:item_id', to:
        'bundles_items_designs#index_items_design_selection', via: :get,as: :index_items_design_selection

  match '/bundles_items_designs/create/bundle_items_design/:bundle_id/:location_id/:items_design_id', to:
         'bundles_items_designs#create_bundle_items_design', via: :post, as: :create_bundle_items_design




  resources :items_locations


  resources :locations


  resources :sections

  resources :password_resets

  resources :notifications

  resources :feedbacks

  resources :bundles_bookmarks

  resources :bookmarks

  match '/bookmarks/index/bookmarks_approval', to:
         'bookmarks#index_bookmarks_approval', via: :get,as:
                    :index_bookmarks_approval
  match '/bookmarks/update/bookmarks_approval_for_a_user/:bookmark_id', to:
         'bookmarks#update_bookmarks_approval_for_a_user', via: :put,as:
                   :update_bookmarks_approval_for_a_user
  match '/bookmarks/update/bookmarks_approval_for_all_users/:bookmark_id', to:
         'bookmarks#update_bookmarks_approval_for_all_users', via: :put,as:
                   :update_bookmarks_approval_for_all_users


  resources :items_designs

  resources :bookmarks_categories

  resources :themes

  resources :bundles

  match '/bundles/active_update/:id', to:
         'bundles#active_update', via: :put,as:
         :bundles_active_update
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

  #room page
  match '/room/:username', to: 'rooms#room', via: :get,as: :room_rooms

  #match '/xroom/:username', to: 'rooms#xroom', via: :get,as: :xroom_rooms


  root to: 'static_pages#home'
  #root to: 'users#new'


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
#  Start Items contract
#**************************

  match 'items/json/index_items', to:
        'items#json_index_items', via: :get, as:
        :items_json_index_items




 #**************************
 #  Start Themes contract
 #**************************

  match 'themes/json/index_themes', to:
        'themes#json_index_themes', via: :get, as:
        :themes_json_index_themes

  match 'themes/json/show_theme_by_theme_id/:theme_id', to:
        'themes#json_show_theme_by_theme_id', via: :get ,as:
        :themes_json_show_theme_by_theme_id

  match 'themes/json/index_themes_categories', to:
        'themes#json_index_themes_categories', via: :get ,as:
         :themes_json_index_themes_categories


  match '/themes/json/index_themes_filter_by_category_by_keyword_and_limit_and_offset/:category/:keyword/:limit/:offset', to:
         'themes#json_index_themes_filter_by_category_by_keyword_and_limit_and_offset', via: :get ,as:
          :themes_index_themes_filter_by_category_by_keywor_and_limit_and_offset






  #--------------------------
  # end Themes contract
  #--------------------------



  #**************************
  #  start Rooms contract
  #**************************
  match '/rooms/json/show_room_by_user_id/:user_id', to:
         'rooms#json_show_room_by_user_id', via: :get ,as:
         :rooms_json_show_room_by_user_id

  match '/rooms/json/show_room_user', to:
        'rooms#json_show_room_user', via: :get ,as:
        :rooms_json_show_room_user



  #--------------------------
  # end Rooms contract
  #--------------------------


  #**************************
  #  start Bundles contract
  #**************************
  match '/bundles/json/index_bundles', to:
         'bundles#json_index_bundles', via: :get , as:
         :bundles_json_index_bundles

  match '/bundles/json/index_bundles_categories', to:
         'bundles#json_index_bundles_categories', via: :get , as:
         :bundles_json_index_bundles_categories


  match '/bundles/json/index_bundles_filter_by_category_by_keyword_and_limit_and_offset/:category/:keyword/:limit/:offset', to:
         'bundles#json_index_bundles_filter_by_category_by_keyword_and_limit_and_offset', via: :get  , as:
         :bundles_json_index_bundles_filter_by_category_by_keyword_and_limit_and_offset




  #--------------------------
  # end Bundles contract
  #--------------------------


  #**************************
  #  start Searches contract
  #**************************

  match '/searches/json/index_searches_items_themes_bundles_bookmarks_users_with_limit_and_offset_and_keyword/:limit/:offset/:keyword', to:
         'searches#json_index_searches_items_themes_bundles_bookmarks_users_with_limit_and_offset_and_keyword', via: :get, as:
         :searches_json_index_searches_items_themes_bundles_bookmarks_users_with_limit_and_offset_and_keyword

  match '/searches/json/index_searches_items_designs_with_limit_and_offset_and_keyword/:limit/:offset/:keyword', to:
         'searches#json_index_searches_items_designs_with_limit_and_offset_and_keyword', via: :get, as:
         :searches_json_index_searches_items_designs_with_limit_and_offset_and_keyword

  match '/searches/json/index_searches_themes_with_limit_and_offset_and_keyword/:limit/:offset/:keyword', to:
         'searches#json_index_searches_themes_with_limit_and_offset_and_keyword', via: :get, as:
         :searches_json_index_searches_themes_with_limit_and_offset_and_keyword

  match '/searches/json/index_searches_bundles_with_limit_and_offset_and_keyword/:limit/:offset/:keyword', to:
         'searches#json_index_searches_bundles_with_limit_and_offset_and_keyword', via: :get, as:
         :searches_json_index_searches_bundles_with_limit_and_offset_and_keyword

  match '/searches/json/index_searches_bookmarks_with_limit_and_offset_and_keyword/:limit/:offset/:keyword', to:
         'searches#json_index_searches_bookmarks_with_limit_and_offset_and_keyword', via: :get, as:
         :searches_json_index_searches_bookmarks_with_limit_and_offset_and_keyword


  match '/searches/json/index_searches_items_designs_with_item_id_and_limit_and_offset_and_keyword/:item_id/:limit/:offset/:keyword', to:
        'searches#json_index_searches_items_designs_with_item_id_and_limit_and_offset_and_keyword', via: :get, as:
            :searches_json_index_searches_items_designs_with_item_id_and_limit_and_offset_and_keyword

  match '/searches/json/index_searches_users_profile_with_limit_and_offset_and_keyword/:limit/:offset/:keyword', to:
         'searches#json_index_searches_users_profile_with_limit_and_offset_and_keyword', via: :get, as:
         :searches_json_index_searches_users_profile_with_limit_and_offset_and_keyword



  #--------------------------
  # end Searches contract
  #--------------------------


  #**************************
  # start ItemsDesigns Contract
  #**************************

  match '/items_designs/json/index_items_designs_by_item_id/:item_id', to:
         'items_designs#json_index_items_designs_by_item_id', via: :get  , as:
         :items_designs_json_index_items_designs_by_item_id

  match '/items_designs/json/index_random_items_by_limit_by_offset/:limit/:offset', to:
         'items_designs#json_index_random_items_by_limit_by_offset', via: :get  , as:
         :items_designs_json_index_items_designs_by_item_id

  match '/items_designs/json/index_items_designs_of_bundle_by_bundle_id/:bundle_id', to:
         'items_designs#json_index_items_designs_of_bundle_by_bundle_id', via: :get  , as:
         :items_designs_json_index_items_designs_of_bundle_by_bundle_id

  match '/items_designs/json/index_items_designs_categories_by_item_id/:item_id', to:
         'items_designs#json_index_items_designs_categories_by_item_id', via: :get  , as:
         :items_designs_json_index_items_designs_categories_by_item_id

  match '/items_designs/json/index_items_designs_filter_by_category_by_item_id_by_keyword_and_limit_and_offset/:category/:item_id/:keyword/:limit/:offset', to:
         'items_designs#json_index_items_designs_filter_by_category_by_item_id_by_keyword_and_limit_and_offset', via: :get  , as:
         :items_designs_json_index_items_designs_filter_by_category_by_item_id_by_keyword_and_limit_and_offset

  match '/items_designs/json/show_items_design_seo_url_by_items_design_id/:items_design_id', to:
         'items_designs#json_show_items_design_seo_url_by_items_design_id', via: :get








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


  match '/users/json/show_signed_user', to:
         'users#json_show_signed_user', via: :get , as:
         :users_json_show_signed_user








  #--------------------------
  # end Users Contract
  #--------------------------



  #**************************
  #  start UsersThemes Contract
  #**************************

  match '/users_themes/json/update_user_theme_by_user_id_and_section_id/:user_id/:section_id', to:
         'users_themes#json_update_user_theme_by_user_id_and_section_id', via: :put

  match '/users_themes/json/show_user_theme_by_user_id_and_section_id/:user_id/:section_id', to:
         'users_themes#json_show_user_theme_by_user_id_and_section_id', via: :get , as:
         :users_themes_json_show_user_theme_by_user_id_and_section_id



  #--------------------------
  #  end UsersThemes Contract
  #--------------------------

  #**************************
  # start UsersItemsDesign Contract
  #**************************


  match '/users_items_designs/json/update_user_items_design_by_user_id_and_items_design_id_and_location_id/:user_id/:items_design_id/:location_id', to:
         'users_items_designs#json_update_user_items_design_by_user_id_and_items_design_id_and_location_id', via: :put


  match '/users_items_designs/json/update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id/:user_id/:items_design_id/:location_id', to:
         'users_items_designs#json_update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id', via: :put

  match '/users_items_designs/json/index_user_items_designs_by_user_id/:user_id', to:
         'users_items_designs#json_index_user_items_designs_by_user_id', via: :get, as:
         :users_items_designs_json_index_user_items_designs_by_user_id


  match '/users_items_designs/json/show_user_items_design_by_user_id_and_items_design_id/:user_id/:items_design_id', to:
         'users_items_designs#json_show_user_items_design_by_user_id_and_items_design_id', via: :get, as:
         :users_items_designs_json_show_user_items_design_by_user_id_and_items_design_id

  match '/users_items_designs/json/index_user_items_designs_by_user_id_and_section_id/:user_id/:section_id', to:
         'users_items_designs#json_index_user_items_designs_by_user_id_and_section_id', via: :get, as:
         :users_items_designs_json_index_user_items_designs_by_user_id_and_section_id


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

    match '/users_bookmarks/json/show_user_bookmark_by_user_id_and_bookmark_id/:user_id/:bookmark_id', to:
           'users_bookmarks#json_show_user_bookmark_by_user_id_and_bookmark_id', via: :get, as:
           :users_bookmarks_json_show_user_bookmark_by_user_id_and_bookmark_id









  #--------------------------
  # end UsersBookmark Contract
  #--------------------------


  #**************************
  # start BookmarksCategory Contract
  #**************************


  match '/bookmarks_categories/json/index_bookmarks_categories_by_item_id/:item_id', to:
         'bookmarks_categories#json_index_bookmarks_categories_by_item_id', via: :get, as:
         :bookmarks_categories_json_index_bookmarks_categories_by_item_id


  #**************************
  # end BookmarksCategory Contract
  #**************************



  #**************************
  # start Bookmarks Contract
  #**************************

  match '/bookmarks/json/index_bookmarks_with_bookmarks_category_by_item_id/:item_id', to:
         'bookmarks#json_index_bookmarks_with_bookmarks_category_by_item_id', via: :get, as:
         :bookmarks_json_index_bookmarks_with_bookmarks_category_by_item_id

  match '/bookmarks/json/index_bookmarks_with_bookmarks_that_need_to_be_approve_by_user_id_and_by_item_id/:user_id/:item_id', to:
         'bookmarks#json_index_bookmarks_with_bookmarks_that_need_to_be_approve_by_user_id_and_by_item_id', via: :get, as:
         :bookmarks_json_index_bookmarks_with_bookmarks_that_need_to_be_approve_by_user_id_and_by_item_id

  match '/bookmarks/json/index_random_bookmarks_by_limit_by_offset/:limit/:offset', to:
         'bookmarks#json_index_random_bookmarks_by_limit_by_offset', via: :get  , as:
          :bookmarks_json_index_random_bookmarks_by_limit_by_offset


  match '/bookmarks/json/index_bookmarks_by_bookmarks_category_id/:bookmarks_category_id', to:
         'bookmarks#json_index_bookmarks_by_bookmarks_category_id', via: :get  , as:
                   :json_index_bookmarks_by_bookmarks_category_id

  match 'bookmarks/json/show_bookmark_by_bookmark_id/:bookmark_id', to:
        'bookmarks#json_show_bookmark_by_bookmark_id', via: :get  , as:
        :json_show_bookmark_by_bookmark_id








  #**************************
  # end Bookmarks Contract
  #**************************


  #**************************
  # start FriendRequest Contract
  #**************************

  match '/friend_requests/json/create_friend_request_by_user_id_and_user_id_requested/:user_id/:user_id_requested', to:
         'friend_requests#json_create_friend_request_by_user_id_and_user_id_requested', via: :post

  match '/friend_requests/json/destroy_friend_request_by_user_id_and_user_id_that_make_request/:user_id/:user_id_that_make_request', to:
         'friend_requests#json_destroy_friend_request_by_user_id_and_user_id_that_make_request', via: :delete

  match '/friend_requests/json/index_friend_request_make_from_your_friend_to_you_by_user_id/:user_id', to:
         'friend_requests#json_index_friend_request_make_from_your_friend_to_you_by_user_id', via: :get, as:
         :friend_requests_json_index_friend_request_make_from_your_friend_to_you_by_user_id


  match '/friend_requests/json/show_friend_request_by_user_id_user_id_requested/:user_id/:user_id_requested', to:
         'friend_requests#json_show_friend_request_by_user_id_user_id_requested', via: :get






  #json_index_friend_request_make_from_your_friend_to_you_by_user_id
  #**************************
  # end FriendRequest Contract
  #**************************



  #**************************
  # start Friend Contract
  #**************************

  match '/friends/json/destroy_friend_by_user_id_and_user_id_friend/:user_id/:user_id_friend', to:
         'friends#json_destroy_friend_by_user_id_and_user_id_friend', via: :delete

  match '/friends/json/create_friend_by_user_id_accept_and_user_id_request/:user_id/:user_id_request', to:
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

  match '/friends/json/show_is_my_friend_by_user_id_and_friend_id/:user_id/:friend_id', to:
        'friends#json_show_is_my_friend_by_user_id_and_friend_id', via: :get, as:
        :friends_json_show_is_my_friend_by_user_id_and_friend_id


  #match '/friends/json/is_my_friend_the_sign_in_by_friend_id/:user_id', to:
  #       'friends#json_is_my_friend_the_sign_in_by_friend_id', via: :get







  #**************************
  # end Friend Contract
  #**************************




  #**************************
  # start UsersPhotos Contract
  #**************************

  match '/users_photos/json/create_users_photo_by_user_id/:user_id', to:
         'users_photos#json_create_users_photo_by_user_id', via: :post

  match '/users_photos/json/update_users_set_profile_image_by_user_id_and_users_photo_id/:user_id/:users_photo_id', to:
         'users_photos#json_update_users_set_profile_image_by_user_id_and_users_photo_id', via: :put

  match '/users_photos/json/index_users_photos_by_user_id_by_limit_by_offset/:user_id/:limit/:offset', to:
         'users_photos#json_index_users_photos_by_user_id_by_limit_by_offset', via: :get , as:
          :users_photos_json_index_users_photos_by_user_id_by_limit_by_offset


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

  #**************************
  # start Notification Contract
  #**************************

  match '/notifications/json/index_notification_by_limit_by_offset/:limit/:offset', to:
         'notifications#json_index_notification_by_limit_by_offset', via: :get, as:
          :notifications_json_index_notification_by_limit_by_offset


  #**************************
  # start location Contract
  #**************************

  match '/locations/json/show_location_by_location_id/:location_id', to:
         'locations#json_show_location_by_location_id', via: :get, as:
         :locations_json_show_location_by_location_id





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
