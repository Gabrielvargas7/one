require 'spec_helper'

describe SearchesController do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do
    #@theme = FactoryGirl.create(:theme)
    #@admin = FactoryGirl.create(:admin)
    #sign_in @admin
    ##puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end


  #the (subject)line declare the variable that is use in all the test
  #subject { @theme }


  # GET get search items,themes, bundles,bookmarks,users by the keyword with limit and offset
  # Limit is the number of returns by type that you want it
  # Offset is where you want to start
  # /searches/json/index_searches_items_themes_bundles_bookmarks_users_with_limit_and_offset_and_keyword/:limit/:offset/:keyword
  # /searches/json/index_searches_items_themes_bundles_bookmarks_users_with_limit_and_offset_and_keyword/10/0/gabriel var.json
  #Return head
  #success    ->  head  200 OK

  #def json_index_searches_items_themes_bundles_bookmarks_users_with_limit_and_offset_and_keyword


  describe "api #json_index_searches_items_themes_bundles_bookmarks_users_with_limit_and_offset_and_keyword",tag_json_search:true do

    describe "profile" do
      before do
        @user1 = FactoryGirl.create(:user,email:"gabriel@gmail.com")
        @user2 = FactoryGirl.create(:user,email:"gaby@gmail.com")
        @user3 = FactoryGirl.create(:user,email:"rooms@gmail.com")
        @user4 = FactoryGirl.create(:user,email:"roomsy@gmail.com")
        @user_profile1 = UsersProfile.find_all_by_user_id(@user3.id).first
        @user_profile1.firstname = "gabrielvar"
        @user_profile1.save!

        @user_profile2 = UsersProfile.find_all_by_user_id(@user4.id).first
        @user_profile2.lastname = "var"
        @user_profile2.save!

        @item = Item.find(ItemsDesign.first.item_id)
        @item.name = "chair"
        @item.save!

        @keyword = "gab var brand chair tit"
        @limit = 10
        @offset = 0
      end


      it "should be successful" do
        get :json_index_searches_items_themes_bundles_bookmarks_users_with_limit_and_offset_and_keyword,keyword:@keyword,limit:@limit,offset:@offset, :format => :json
        response.should be_success
      end

      it "has a 200 status code" do
        get :json_index_searches_items_themes_bundles_bookmarks_users_with_limit_and_offset_and_keyword,keyword:@keyword,limit:@limit,offset:@offset, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do
        it "should return json_index theme in json" do # depend on what you return in action
          get :json_index_searches_items_themes_bundles_bookmarks_users_with_limit_and_offset_and_keyword,keyword:@keyword,limit:@limit,offset:@offset, :format => :json
          body = JSON.parse(response.body)
          puts body.as_json
          # Test user
          body["users"].each do |user|

            @user_json = User.find(user["user_id"])
            @user_photo_json = UsersPhoto.find_all_by_user_id(@user_json.id).first

            #puts "image_name: "+@user_photo_json.image_name.to_s
            puts "username: "+user["username"].as_json

            user["username"].should == @user_json.username
            user["user_id"].should == @user_json.id

            user["image_name"]["url"].should == @user_photo_json.image_name.to_s
          end
          # Test user profile
          body["users_profiles"].each do |user|

            @user_profile_json = UsersProfile.find(user["user_id"])
            @user_photo_json = UsersPhoto.find_all_by_user_id(@user_profile_json.id).first

            puts "first name: "+user["firstname"].to_s
            puts "last name: "+user["lastname"].to_s

            user["firstname"].should == @user_profile_json.firstname
            user["lastname"].should == @user_profile_json.lastname
            user["user_id"].should == @user_profile_json.user_id
            user["image_name"]["url"].should == @user_photo_json.image_name.to_s
          end

          body["themes"].each do |theme|
            puts theme["name"]
            @theme_json = Theme.find(theme["id"])
            theme["name"].should == @theme_json.name
            theme["description"].should == @theme_json.description
            theme["id"].should == @theme_json.id
            theme["image_name"]["url"].should == @theme_json.image_name.to_s

            theme["image_name_selection"]["url"].should == @theme_json.image_name_selection.to_s
            theme["category"].should == @theme_json.category
            theme["style"].should == @theme_json.style
            theme["brand"].should == @theme_json.brand
            theme["location"].should == @theme_json.location
            theme["color"].should == @theme_json.color
            theme["make"].should == @theme_json.make
            theme["special_name"].should == @theme_json.special_name
            theme["like"].should == @theme_json.like
          end

          body["items_designs"].each do |items_design|

            puts "item design ------->"+items_design["id"].to_s
            puts "item name ------>"+items_design["items_name"].to_s

            @items_design_json = ItemsDesign.find(items_design["id"])
            @item_json = Item.find(@items_design_json.item_id)

            items_design["description"].should == @items_design_json.description
            items_design["id"].should == @items_design_json.id
            items_design["image_name"]["url"].should == @items_design_json.image_name.to_s
            items_design["image_name_hover"]["url"].should == @items_design_json.image_name_hover.to_s
            items_design["image_name_selection"]["url"].should == @items_design_json.image_name_selection.to_s
            items_design["item_id"].should == @items_design_json.item_id
            items_design["name"].should == @items_design_json.name
            items_design["category"].should == @items_design_json.category
            items_design["style"].should == @items_design_json.style
            items_design["brand"].should == @items_design_json.brand
            items_design["color"].should == @items_design_json.color
            items_design["make"].should == @items_design_json.make
            items_design["special_name"].should == @items_design_json.special_name
            items_design["like"].should == @items_design_json.like
            items_design["items_name"].should == @item_json.name

          end

          body["bundles"].each do |body_bundle|
            @bundle_json = Bundle.find(body_bundle["id"])
            puts "bundle name ------>"+body_bundle["name"].to_s
            body_bundle["name"].should == @bundle_json.name
            body_bundle["description"].should == @bundle_json.description
            body_bundle["id"].should == @bundle_json.id
            body_bundle["image_name"]["url"].should == @bundle_json.image_name.to_s
            body_bundle["image_name_set"]["url"].should == @bundle_json.image_name_set.to_s
            body_bundle["section_id"].should == @bundle_json.section_id
            body_bundle["active"].should == 'y'
            body_bundle["category"].should == @bundle_json.category
            body_bundle["style"].should == @bundle_json.style
            body_bundle["brand"].should == @bundle_json.brand
            body_bundle["location"].should == @bundle_json.location
            body_bundle["color"].should == @bundle_json.color
            body_bundle["make"].should == @bundle_json.make
            body_bundle["special_name"].should == @bundle_json.special_name
            body_bundle["like"].should == @bundle_json.like
          end

          body["bookmarks"].each do |body_bookmark|
            @bookmark_json = Bookmark.find(body_bookmark["id"])
            @bookmarks_category_json = BookmarksCategory.find(body_bookmark["bookmarks_category_id"])
            puts "bookmark title ------>"+body_bookmark["title"].to_s

            body_bookmark["id"].should == @bookmark_json.id
            body_bookmark["bookmark_url"].should == @bookmark_json.bookmark_url
            body_bookmark["bookmarks_category_id"].should == @bookmark_json.bookmarks_category_id
            body_bookmark["bookmarks_category_name"].should == @bookmarks_category_json.name
            body_bookmark["description"].should == @bookmark_json.description
            body_bookmark["title"].should == @bookmark_json.title
            body_bookmark["image_name"]["url"].should == @bookmark_json.image_name.to_s
            body_bookmark["image_name_desc"]["url"].should == @bookmark_json.image_name_desc.to_s
            body_bookmark["like"].should == @bookmark_json.like

          end
        end
      end

    end
  end




end
