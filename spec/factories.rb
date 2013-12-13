#FactoryGirl.define do
#  factory :user do
#    name     "Michael Hartl"
#    email    "michael@example.com"
#    password "foobar"
#    password_confirmation "foobar"
#  end
#end


FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "person_#{n}@example.com"}
    sequence(:username)  {|n| "username#{n}"}

    password "foodbar"

    factory :admin do
      admin true
    end


  end


  factory :section do
    sequence(:name)  { |n| "section #{n}" }
    sequence(:description)  { |n| "desc #{n}" }
  end


  factory :theme do
    sequence(:name)  { |n| "theme #{n}" }
    sequence(:description)  { |n| "desc #{n}" }
    category "category"
    style "style"
    brand "brand"
    location "location"
    color "color"
    make "make"
    special_name "special_name"
    like 1

  end




  factory :bundle do
    sequence(:name)  { |n| "bundle #{n}" }
    sequence(:description)  { |n| "desc #{n}" }
    theme_id 1
    section_id 1
    active 'n'
    category "category"
    style "style"
    brand "brand"
    location "location"
    color "color"
    make "make"
    special_name "special_name"
    like 1
  end

  factory :item do
    sequence(:name)  { |n| "item #{n}" }
    sequence(:name_singular)  { |n| "item singular#{n}" }
    clickable  "yes"
    priority_order 1
  end

  factory :location do
    sequence(:name)  { |n| "location #{n}" }
    description "location"
    section_id 1
    height 10
    width 10
    x 1
    y 2
    z 3
  end

  factory :items_location do
    item_id 1
    location_id 1
  end


  factory :items_design do
    sequence(:name)  { |n| "itemdesign #{n}" }
    sequence(:description)  { |n| "desc #{n}" }
    item_id 1
    category "category"
    style "style"
    brand "brand"
    color "color"
    make "make"
    special_name "special_name"
    like 1
  end


  factory :bookmarks_category do
    sequence(:name)  { |n| "bookmarks_category #{n}" }
    item_id 1
  end


  factory :bookmark do
    sequence(:title)  { |n| "title #{n}" }
    sequence(:description)  { |n| "desc #{n}" }
    sequence(:bookmark_url)  { |n| "http://example#{n}.com" }
    sequence(:image_name_desc)  { |n| "image_name_desc #{n}" }
    i_frame  "y"
    bookmarks_category_id 1
    approval 'y'
    user_bookmark 0 # zero is when all have access to the bookmark
    like 1
  end


  factory :bundles_bookmark do
    bookmark_id 1

  end


  factory :bundles_items_design do
    bundle_id 1
    location_id 1
    items_design_id 1
  end


  factory :feedback do
    description "feedback one"
    email "feedback@mywebroom.com"
    name "feedback"
    user_id 1
  end



  factory :notification do

    description "noti one"
    name "notification"
    user_id 1
    position 1
  end


  factory :friend_request do
    user_id 1
    user_id_requested 2
  end

  factory :friend do
    user_id 1
    user_id_friend 2
  end


  factory :users_theme do
    user_id 1
    theme_id 1
    section_id 1

  end

  factory :users_bookmark do
    sequence(:position) { |n| "#{n}" }
    #sequence(:title)  { |n| "title #{n}" }
    user_id 1
    bookmark_id 1
  end

  factory :users_notification do
    user_id 1
    notification_id 1
    notified 'n'
  end

  factory :users_items_design do
    user_id 1
    items_design_id 1
    hide 'no'
    location_id 1
  end

  factory :users_photo do
    sequence(:description) { |n| "description #{n}" }
    profile_image 'n'
    user_id 1
  end


  factory :users_profile do

    sequence(:description) { |n| "description #{n}" }
    city 'city'
    country 'country'
    gender 'gender'
    lastname 'lastname'
    firstname 'firstname'
    birthday Date.today
    user_id 1

  end




end


