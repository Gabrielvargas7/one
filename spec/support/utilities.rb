def full_title(page_title)
  base_title = "Ruby on Rails Tutorial Sample App"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def sign_in(user)
  visit signin_path
  #fill_in "Email",    with: user.email
  #fill_in "Password", with: user.password
  fill_in "Email",    with: 'gabriel@mywebroom.com'
  fill_in "Password", with: 'Franc15c0'


  click_button "LOGIN"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token




  #if user.admin
  #  puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  #else
  #  puts "Regular user signin cookie: "+cookies[:remember_token].to_s
  #end
end

def sign_out
  cookies.delete(:remember_token)
  #puts "user signout cookie: "+cookies[:remember_token].to_s
end


#def wait_for_ajax
#  Timeout.timeout(Capybara.default_wait_time) do
#    active = page.evaluate_script('jQuery.active')
#
#    until active == 0
#      active = page.evaluate_script('jQuery.active')
#    end
#  end
#end
#
#def wait_for_dom(timeout = Capybara.default_wait_time)
#  uuid = SecureRandom.uuid
#  page.find("body")
#  page.evaluate_script <<-EOS
#    _.defer(function() {
#      $('body').append("<div id='#{uuid}'></div>");
#    });
#  EOS
#  page.find("##{uuid}")
#end




def create_init_data


  if Theme.count == 0

    #####################
    #  Creating Section
    #####################


    2.times {FactoryGirl.create(:section)}
    @section = Section.first
    #puts "--- Start creating seed data for test  "

    #####################
    #  Creating Themes
    #####################

    6.times {FactoryGirl.create(:theme,name:"delete_data")}
    @themes = Theme.all


    #####################
    #  Creating Bundles
    #####################

    @themes.each do |theme|
      FactoryGirl.create(:bundle,theme_id:theme.id,section_id:@section.id,active:'y')
    end


    #####################
    #  Creating Item
    #####################

    10.times {FactoryGirl.create(:item)}
    @items = Item.all

    #####################
    #  Creating Locations
    #####################

    #10.times {FactoryGirl.create(:location,section_id:@section.id)}
    #@locations = Location.all
    #
    ##puts "items : " +item.id.to_s
    ##puts "location : "+ location.id.to_s
    #
    #
    #
    #item =  Item.first
    #location = Location.first
    #
    #FactoryGirl.create(:items_location,item_id:item.id,location_id:location.id)
    #
    #item =  Item.last
    #location = Location.last
    #FactoryGirl.create(:items_location,item_id:item.id,location_id:location.id)

    @items.each do |item|
      location = FactoryGirl.create(:location,section_id:@section.id)
      FactoryGirl.create(:items_location,item_id:item.id,location_id:location.id)
      puts "items : " +item.id.to_s
      puts "location : "+ location.id.to_s

    end




    #create the items_design and the bookmarks_category
    @items.each do |item|
      FactoryGirl.create(:items_design,item_id:item.id)
      (1..3).each do |i|
        FactoryGirl.create(:bookmarks_category,item_id:item.id)
      end

      @bookmarks_category = BookmarksCategory.find_by_item_id(item.id)
      (1..3).each do |i|
        FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category.id)
      end
      @bookmarks = Bookmark.
                    joins(:bookmarks_category).
                    where('bookmarks_categories.item_id = ?',item.id)


      @bookmarks.each do |bookmark|
        FactoryGirl.create(:bundles_bookmark,bookmark_id:bookmark.id)
        #puts "items : " +item.id.to_s
        #puts "bundle bookmark : "+ bookmark.id.to_s
      end

    end

    @bundles = Bundle.all

    @bundles.each do |bundle|
      #puts "bundle: "+ bundle.id.to_s


      #items_design = ItemsDesign.first
      #items_location = ItemsLocation.find_by_item_id(items_design.item_id)
      #FactoryGirl.create(:bundles_items_design,bundle_id:bundle.id,location_id:items_location.location_id,items_design_id:items_design.id)
      #
      #items_design = ItemsDesign.last
      #items_location = ItemsLocation.find_by_item_id(items_design.item_id)
      #FactoryGirl.create(:bundles_items_design,bundle_id:bundle.id,location_id:items_location.location_id,items_design_id:items_design.id)


      @items_designs = ItemsDesign.all
      @items_designs.each do |items_design|
        items_location = ItemsLocation.find_by_item_id(items_design.item_id)
        FactoryGirl.create(:bundles_items_design,bundle_id:bundle.id,location_id:items_location.location_id,items_design_id:items_design.id)
        #puts "bundle item designs: "+ items_design.id.to_s

      end


    end

    #puts "--- End creating seed data for test  "

  end
end


def delete_init_data

  #puts "--- Start deleting init data for test  "

  #delete only data when we create
  if Theme.find_by_name("delete_data")

    Section.delete_all
    Location.delete_all
    ItemsLocation.delete_all
    Bundle.delete_all
    Theme.delete_all
    Item.delete_all
    ItemsDesign.delete_all
    BookmarksCategory.delete_all
    Bookmark.delete_all
    BundlesBookmark.delete_all
    BundlesItemsDesign.delete_all

  end


#  puts "--- End deleteing init data for test  "


end

def category_exist?(value)

  case value
    when "category"
      true
    when "style"
      true
    when "brand"
      true
    when "location"
      true
    when "color"
      true
    when "make"
      true
    else
      false
  end




end

