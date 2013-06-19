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
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

def create_init_data

  if Theme.count == 0

    2.times {FactoryGirl.create(:section)}
    @section = Section.first
    puts "--- Start creating seed data for test  "


    5.times {FactoryGirl.create(:theme)}
    @themes = Theme.all

    @themes.each do |theme|
      FactoryGirl.create(:bundle,theme_id:theme.id,section_id:@section.id)
    end
    @bundle = Bundle.first

    2.times {FactoryGirl.create(:item)}
    @items = Item.all

    2.times {FactoryGirl.create(:location,section_id:@section.id)}
    @locations = Location.all

    item =  Item.first
    location = Location.first
    puts "items : " +item.id.to_s
    puts "location : "+ location.id.to_s

    FactoryGirl.create(:items_location,item_id:item.id,location_id:location.id)

    item =  Item.last
    location = Location.last
    FactoryGirl.create(:items_location,item_id:item.id,location_id:location.id)



    #create the items_design and the bookmarks_category
    @items.each do |item|
      FactoryGirl.create(:items_design,item_id:item.id)
      (1..3).each do |i|
        FactoryGirl.create(:bookmarks_category,item_id:item.id)
      end

      @bookmarks_category = BookmarksCategory.find_by_item_id(item.id)
      (1..3).each do |i|
        FactoryGirl.create(:bookmark,item_id:item.id,bookmarks_category_id:@bookmarks_category.id)
      end
      @bookmark = Bookmark.find_by_item_id(item.id)

      FactoryGirl.create(:bundles_bookmark,item_id:item.id,bookmark_id:@bookmark.id)
    end




    items_design = ItemsDesign.first
    items_location = ItemsLocation.find_by_item_id(items_design.item_id)
    FactoryGirl.create(:bundles_items_design,bundle_id:@bundle.id,location_id:items_location.location_id,items_design_id:items_design.id)

    items_design = ItemsDesign.last
    items_location = ItemsLocation.find_by_item_id(items_design.item_id)
    FactoryGirl.create(:bundles_items_design,bundle_id:@bundle.id,location_id:items_location.location_id,items_design_id:items_design.id)


    puts "--- End creating seed data for test  "

  end
end


def delete_init_data

  puts "--- Start deleteing init data for test  "


  Bundle.delete_all
  Theme.delete_all
  Item.delete_all
  ItemsDesign.delete_all
  BookmarksCategory.delete_all
  Bookmark.delete_all
  BundlesBookmark.delete_all
  BundlesItemsDesign.delete_all

  puts "--- End deleteing init data for test  "


end

