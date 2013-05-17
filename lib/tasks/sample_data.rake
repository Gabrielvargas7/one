namespace :db do

  desc "Fill database with sample data"
  task populate: :environment do

    User.delete_all
    UsersItemsDesign.delete_all
    UsersBookmark.delete_all
    UsersTheme.delete_all
    Friend.delete_all
    FriendRequest.delete_all

    ##########
    # create the admin user
    #########
    puts("creating admin user" )
    admin = User.create!(name: "admin user",
                 email: "rooms.team@mywebroom.com",
                 password: "PRico_2000j",
                 password_confirmation: "PRico_2000j")
    admin.toggle!(:admin)


    admin.id
    bundle_max = Bundle.maximum("id")
    bundle_rand_number = rand(1..bundle_max)
    bundle = Bundle.find(bundle_rand_number)

    UsersTheme.create!(user_id:admin.id,theme_id:bundle.theme_id)
    @items_design = ItemsDesign.find_all_by_bundle_id(bundle.id)

    @items_design.each  do |i|
      UsersItemsDesign.create!(user_id:admin.id,items_design_id:i.id,hide:'no')
    end

    @bundle_all = BundlesBookmark.all


    @bundle_all.each do |b|
       UsersBookmark.create!(user_id:admin.id,bookmark_id:b.bookmark_id,position:1)
    end


    ##########
    # create 10 test standard user
    #########
    puts("creating test user" )
    test_user_number = 10
    user_array = Array.new
    test_user_number.times do |n|
      name  = Faker::Name.name
      email = "test#{n+1}@mywebroom.com"
      password  = "password"
      user = User.create!(name: name,
                   email: email,
                   password: "rooms",
                   password_confirmation: "rooms")

      puts("creating user "+user.id.to_s)
      user.id
      user_array[n] = user.id

      bundle_max = Bundle.maximum("id")
      bundle_rand_number = rand(1..bundle_max)
      bundle = Bundle.find(bundle_rand_number)

      UsersTheme.create!(user_id:user.id,theme_id:bundle.theme_id)
      @items_design = ItemsDesign.find_all_by_bundle_id(bundle.id)

      @items_design.each  do |i|
        UsersItemsDesign.create!(user_id:user.id,items_design_id:i.id,hide:'no')
      end

      @bundle_all = BundlesBookmark.all


      @bundle_all.each do |b|

        UsersBookmark.create!(user_id:user.id,bookmark_id:b.bookmark_id,position:1)
      end

    end
    ##########
    # create test 10 standard friend and friend request
    #########
    puts("creating friend and request user" )
    i = 0
    while i < test_user_number-1  do
      puts("creating friend and request "+user_array[i].to_s)
      half_user_number = test_user_number/2

      if i< half_user_number
        FriendRequest.create!(user_id:user_array[i],user_id_requested:user_array[i+1])
      else
        Friend.create!(user_id:user_array[i],user_id_friend:user_array[i+1])
        Friend.create!(user_id:user_array[i+1],user_id_friend:user_array[i])
      end
      i +=1
    end




  end
end