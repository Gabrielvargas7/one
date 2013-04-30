namespace :db do

  desc "Fill database with sample data"
  task populate: :environment do

    User.delete_all
    UsersItemsDesign.delete_all
    UsersBookmark.delete_all
    UsersTheme.delete_all



    admin = User.create!(name: "Example User",
                 email: "test@rooms.org",
                 password: "12345678",
                 password_confirmation: "12345678")
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


    10.times do |n|
      name  = Faker::Name.name
      email = "test#{n+1}@rooms.org"
      password  = "password"
      user = User.create!(name: name,
                   email: email,
                   password: "12345678",
                   password_confirmation: "12345678")


      user.id
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
  end
end