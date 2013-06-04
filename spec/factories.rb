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
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"

    factory :admin do
      admin true
    end


  end


  factory :theme do
    sequence(:name)  { |n| "theme #{n}" }
    sequence(:description)  { |n| "desc #{n}" }

  end

  factory :bundle do
    sequence(:name)  { |n| "bundle #{n}" }
    sequence(:description)  { |n| "desc #{n}" }
    theme_id 1
  end

  factory :item do
    sequence(:name)  { |n| "item #{n}" }
    clickable  "yes"
    height 10
    width 10
    x 1
    y 2
    z 3
  end

  factory :items_design do
    sequence(:name)  { |n| "item_design #{n}" }
    sequence(:description)  { |n| "desc #{n}" }
    bundle_id 1
    item_id 1
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
    item_id 1
    approval 'y'
    user_bookmark 0 # zero is when all have access to the bookmark
  end


  factory :bundles_bookmark do
    bookmark_id 1
    item_id 1
  end







end


