require 'spec_helper'

describe RoomsController do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do

    @user = FactoryGirl.create(:user)
    sign_in @user
    #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @user }


  #***********************************
  # rspec test  /room/:username
  #***********************************

  describe "GET /room/:username",tag_room:true do

    context "is regular user" do


      it "assigns  room as @room" do
        get :room, username:@user.username
        assigns(:user).should eq(@user)
      end

      it "renders the :room view" do
        get :room,username:@user.username
        response.should render_template :room
      end
    end
    context "is public user" do
      before do
        sign_out
      end

      it "assigns  room as @room" do
        get :room, username:@user.username
        assigns(:user).should eq(@user)
      end

      it "renders the :room view" do
        get :room,username:@user.username
        response.should render_template :room
      end
    end

  end

  #***********************************
  # rspec test  json_show_room_by_user_id
  #***********************************


  describe "GET json_show_room_by_user_id", tag_show:true do

          describe "is public api" do
            before do
              sign_out
            end


            it "should be successful" do
              get :json_show_room_by_user_id, user_id: @user.id, :format => :json
              response.should be_success
            end


            #it "should set user" do
            #  get :json_show_room_by_user_id, user_id: @user.id, :format => :json
            #  assigns(:user).as_json.should == @user.as_json
            #end

            it "has a 200 status code" do
              get :json_show_room_by_user_id, user_id: @user.id, :format => :json
              expect(response.status).to eq(200)
            end

            context "get all values " do
              it "should return json_show rooms in json" do # depend on what you return in action


                get :json_show_room_by_user_id, user_id: @user.id, :format => :json

                body = JSON.parse(response.body)
                #puts "----->"+body.to_s
                #puts "--- --->"
                #
                #puts "user --->"+body["user"].to_s
                #puts "user theme --->"+body["user_theme"].to_s
                #puts "user items designs --->"+body["user_items_designs"].to_s
                #puts "user user_photos --->"+body["user_photos"].to_s




                body["user"]["id"].should == @user.id
                body["user"]["username"].should == @user.username

                @user_profile_json = UsersProfile.find_all_by_user_id(body["user"]["id"]).first

                body["user_profile"]["firstname"].should == @user_profile_json.firstname
                body["user_profile"]["lastname"].should == @user_profile_json.lastname
                body["user_profile"]["gender"].should == @user_profile_json.gender
                body["user_profile"]["description"].should == @user_profile_json.description
                body["user_profile"]["city"].should == @user_profile_json.city
                body["user_profile"]["country"].should == @user_profile_json.country
                body["user_profile"]["birthday"].should == @user_profile_json.birthday
                body["user_profile"]["user_id"].should == @user_profile_json.user_id
                body["user_profile"]["friends_number"].should == @user_profile_json.friends_number


                @user_photos_json = UsersPhoto.find_all_by_user_id_and_profile_image(body["user"]["id"],'y').first
                body["user_photos"]["description"].should == @user_photos_json.description
                    body["user_photos"]["id"].should == @user_photos_json.id
                    body["user_photos"]["user_id"].should == @user_photos_json.user_id
                    body["user_photos"]["profile_image"].should == 'y'
                    body["user_photos"]["image_name"]["url"].should == @user_photos_json.image_name.to_s



                #body["user_profile"].each do |user_profile|
                #  #puts user_theme["id"]
                #  @user_profile_json = UsersProfile.find_all_by_user_id(body["user"]["id"]).first
                #  user_profile["firstname"].should == @user_profile_json.firstname
                #  user_profile["lastname"].should == @user_profile_json.lastname
                #  user_profile["gender"].should == @user_profile_json.gender
                #  user_profile["description"].should == @user_profile_json.description
                #  user_profile["city"].should == @user_profile_json.city
                #  user_profile["country"].should == @user_profile_json.country
                #  user_profile["birthday"].should == @user_profile_json.birthday
                #  user_profile["user_id"].should == @user_profile_json.user_id
                #end


                body["user_theme"].each do |user_theme|
                  #puts user_theme["id"]
                  @theme_json = Theme.find(user_theme["id"])
                  user_theme["name"].should == @theme_json.name
                  user_theme["description"].should == @theme_json.description
                  user_theme["id"].should == @theme_json.id
                  user_theme["image_name"]["url"].should == @theme_json.image_name.to_s

                  user_theme["image_name_selection"]["url"].should == @theme_json.image_name_selection.to_s
                  user_theme["category"].should == @theme_json.category
                  user_theme["style"].should == @theme_json.style
                  user_theme["brand"].should == @theme_json.brand
                  user_theme["location"].should == @theme_json.location
                  user_theme["color"].should == @theme_json.color
                  user_theme["make"].should == @theme_json.make
                  user_theme["special_name"].should == @theme_json.special_name
                  user_theme["like"].should == @theme_json.like

                end

                body["user_items_designs"].each do |user_items_designs|
                  #puts "item design ------->"+user_items_designs.to_s
                  #puts "item design ------->"+user_items_designs["id"].to_s

                  @user_items_designs_json = ItemsDesign.find(user_items_designs["id"])
                  user_items_designs["description"].should == @user_items_designs_json.description
                  #user_items_designs["height"].should == @user_items_designs_json.item.height
                  #user_items_designs["hide"].should == @user_items_designs_json.hide
                  user_items_designs["id"].should == @user_items_designs_json.id
                  user_items_designs["image_name"]["url"].should == @user_items_designs_json.image_name.to_s
                  user_items_designs["image_name_hover"]["url"].should == @user_items_designs_json.image_name_hover.to_s
                  user_items_designs["image_name_selection"]["url"].should == @user_items_designs_json.image_name_selection.to_s
                  user_items_designs["item_id"].should == @user_items_designs_json.item_id
                  user_items_designs["name"].should == @user_items_designs_json.name
                  user_items_designs["category"].should == @user_items_designs_json.category
                  user_items_designs["style"].should == @user_items_designs_json.style
                  user_items_designs["brand"].should == @user_items_designs_json.brand
                  user_items_designs["color"].should == @user_items_designs_json.color
                  user_items_designs["make"].should == @user_items_designs_json.make
                  user_items_designs["special_name"].should == @user_items_designs_json.special_name
                  user_items_designs["like"].should == @user_items_designs_json.like

                end



              end
            end
          end
        end

  end

  describe "Room api" do
    pending "add test items with image first_time_click on the room api #{__FILE__}"
  end

