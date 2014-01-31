require 'spec_helper'


describe "This application" do

  #********
  # LEVEL 1
  #********

  # THEME
  # Requirements:
  # name: 1 - 100 characters
  it "can create a theme" do
    theme = Theme.create(name: "a")
    expect(theme).to be_valid
  end


  # SECTION
  # Requirements:
  # name: not blank
  it "can create a section" do
    section = Section.create(name: "a")
    expect(section).to be_valid
  end


  # COMPANY
  # Requirements:
  # name: unique
  it "can create a company" do
    company = Company.create(name: "a")
    expect(company).to be_valid
  end


  # ITEM
  # Requirements:
  # name: 1 - 100 characters
  # name_singular: 1 - 100 characters
  # clickable: 'yes' or 'no' (default 'yes')
  # priority_order: number (default 0)
  it "can create an item" do
    item = Item.create(name: "a", name_singular: "a")
    expect(item).to be_valid
  end




  #********
  # LEVEL 2
  #********

  # BUNDLE
  # Requirements:
  # <theme>, <section>
  # name: 1 - 100 characters
  # active: 'y' or 'n' (default 'n')
  # like: integer (default 0)
  it "can create a bundle" do
    theme = Theme.create(name: "a")
    section = Section.create(name: "a")
    bundle = Bundle.create(name: "a", theme_id: theme.id, section_id: section.id)
    expect(bundle).to be_valid
  end


  # LOCATION
  # Requirements:
  # <section>
  # name: presence
  # height: integer
  # width: integer
  # x: number
  # y: number
  # z: integer
  it "can create a location" do
    # section
    section = Section.create(name: "a")

    # location
    location = Location.create(section_id: section.id, name: "a", height: 0, width: 0, x: 0, y: 0, z: 0)
    expect(location).to be_valid
  end


  # DESIGN
  # Requirements:
  # <company>, <item>
  # name: 1 - 100 characters
  # like: integer (default 0)
  # price: number (default 0.0)
  it "can create a design" do
    # company
    company = Company.create(name: "a")

    # item
    item = Item.create(name: "a", name_singular: "a")

    # design
    design = ItemsDesign.create(company_id: company.id, item_id: item.id, name: "a")
    expect(design).to be_valid
  end


  # BOOKMARK CATEGORY
  # Requirements:
  # <item>
  # name: presence
  it "can create a bookmark category" do
    # item
    item = Item.create(name: "a", name_singular: "a")

    # bookmark category
    bookmark_category = BookmarksCategory.create(item_id: item.id, name: "a")
    expect(bookmark_category).to be_valid
  end




  #********
  # LEVEL 3
  #********

  # USER
  # Requirements:
  # "active" <bundle>
  # email: valid email, unique
  # password: 6+ characters
  # username: unique
  it "can create a user" do
    # bundle
    theme = Theme.create(name: "a")
    section = Section.create(name: "a")
    Bundle.create(name: "a", theme_id: theme.id, section_id: section.id, active: 'y')

    # user
    user = User.create(email: "a@a.a", password: "aaabbb", username: "a")
    expect(user).to be_valid
  end

  it "fails to create a user when no 'active' bundle exists" do
    # user
    user = User.create(email: "a@a.a", password: "aaabbb", username: "a")

    expect(user).not_to be_valid
  end

  it "can turn a user into an admin" do
    # bundle
    theme = Theme.create(name: "a")
    section = Section.create(name: "a")
    Bundle.create(name: "a", theme_id: theme.id, section_id: section.id, active: 'y')

    # user
    user = User.create(email: "a@a.a", password: "aaabbb", username: "a")
    user.admin = true
    user.save
    expect(user.admin).to be(true)
  end


  # BUNDLE DESIGN
  # Requirements:
  # <bundle>, <location>, <design>
  it "can create a bundle design" do
    # bundle
    theme = Theme.create(name: "a")
    section = Section.create(name: "a")
    bundle = Bundle.create(name: "a", theme_id: theme.id, section_id: section.id)

    # location
    # --> use above section <--
    location = Location.create(section_id: section.id, name: "a", height: 0, width: 0, x: 0, y: 0, z: 0)

    # design
    company = Company.create(name: "a")
    item = Item.create(name: "a", name_singular: "a")
    design = ItemsDesign.create(company_id: company.id, item_id: item.id, name: "a")


    # bundle design
    bundle_design = BundlesItemsDesign.create(bundle_id: bundle.id, location_id: location.id, items_design_id: design.id)
    expect(bundle_design).to be_valid
  end


  # ITEM LOCATION
  # Requirements:
  # <location>, <item>
  it "can create an item location" do
    # location
    section = Section.create(name: "a")
    location = Location.create(section_id: section.id, name: "a", height: 0, width: 0, x: 0, y: 0, z: 0)

    # item
    item = Item.create(name: "a", name_singular: "a")

    # item location
    item_location = ItemsLocation.create(location_id: location.id, item_id: item.id)
    expect(item_location).to be_valid
  end


  # BOOKMARK
  # Requirements:
  # <bookmark category>
  # i_frame: 'y' or 'n' (default 'y')
  # bookmark_url: starts with http or https
  # title: 1 - 100 characters
  # approval: 'y' or 'n' (default 'y')
  # user_bookmark: integer (default 0)
  # like: integer (default 0)
  it "can create a bookmark" do
    # bookmark category
    item = Item.create(name: "a", name_singular: "a")
    bookmark_category = BookmarksCategory.create(item_id: item.id, name: "a")

    bookmark = Bookmark.create(bookmarks_category_id: bookmark_category.id, bookmark_url: "https://example.com", title: "a")
    expect(bookmark).to be_valid
  end




  #********
  # LEVEL 4
  #********

  # USER THEME
  # Requirements:
  # <theme>, <section>, <user>
  it "can create a user theme" do
    # theme
    theme = Theme.create(name: "a")

    # section
    section = Section.create(name: "a")

    # user
    theme = Theme.create(name: "a")
    section = Section.create(name: "a")
    Bundle.create(name: "a", theme_id: theme.id, section_id: section.id, active: 'y')
    user = User.create(email: "a@a.a", password: "aaabbb", username: "a")


    # user theme
    user_theme = UsersTheme.create(theme_id: theme.id, section_id: section.id, user_id: user.id)
    expect(user_theme).to be_valid
  end


  # FEEDBACK
  # Requirements:
  # none
  it "can create a feedback" do
    feedback = Feedback.create
    expect(feedback).to be_valid
  end

  it "allows feedback to take a user" do
    # user
    theme = Theme.create(name: "a")
    section = Section.create(name: "a")
    Bundle.create(name: "a", theme_id: theme.id, section_id: section.id, active: 'y')
    user = User.create(email: "a@a.a", password: "aaabbb", username: "a")


    # feedback
    feedback = Feedback.create(user_id: user.id)
    expect(feedback).to be_valid
  end


  # FRIEND
  # Requirements:
  # <user> x 2
  it "can create a friend" do
    # user 1
    theme = Theme.create(name: "a")
    section = Section.create(name: "a")
    Bundle.create(name: "a", theme_id: theme.id, section_id: section.id, active: 'y')
    user_1 = User.create(email: "a@a.a", password: "aaabbb", username: "a")

    # user 2
    user_2 = User.create(email: "b@b.b", password: "aaabbb", username: "b")


    # friend
    friend = Friend.create(user_id: user_1.id, user_id_friend: user_2.id)
    expect(friend).to be_valid
  end

  it "does not create a friend when user does not have profile" do
    # user 1
    theme = Theme.create(name: "a")
    section = Section.create(name: "a")
    Bundle.create(name: "a", theme_id: theme.id, section_id: section.id, active: 'y')
    user_1 = User.create(email: "a@a.a", password: "aaabbb", username: "a")

    # user 2
    user_2 = User.create(email: "b@b.b", password: "aaabbb", username: "b")


    # DELETE PROFILE
    UsersProfile.find_by_user_id(user_1.id).delete


    # friend
    friend = Friend.create(user_id: user_1.id, user_id_friend: user_2.id)
    expect(friend).not_to be_valid
  end

  it "does not create a friend when user and friend are the same" do
    # user 1
    theme = Theme.create(name: "a")
    section = Section.create(name: "a")
    Bundle.create(name: "a", theme_id: theme.id, section_id: section.id, active: 'y')
    user = User.create(email: "a@a.a", password: "aaabbb", username: "a")


    # friend
    friend = Friend.create(user_id: user.id, user_id_friend: user.id)
    expect(friend).not_to be_valid
  end


  # FRIEND REQUEST
  # Requirements:
  # <user> x 2
  it "can create a friend request" do
    # user 1
    theme = Theme.create(name: "a")
    section = Section.create(name: "a")
    Bundle.create(name: "a", theme_id: theme.id, section_id: section.id, active: 'y')
    user_1 = User.create(email: "a@a.a", password: "aaabbb", username: "a")

    # user 2
    user_2 = User.create(email: "b@b.b", password: "aaabbb", username: "b")


    # friend request
    friend_request = FriendRequest.create(user_id: user_1.id, user_id_requested: user_2.id)
    expect(friend_request).to be_valid
  end

  it "does not create a friend request when friend does not exist" do
    # user 1
    theme = Theme.create(name: "a")
    section = Section.create(name: "a")
    Bundle.create(name: "a", theme_id: theme.id, section_id: section.id, active: 'y')
    user = User.create(email: "a@a.a", password: "aaabbb", username: "a")


    # friend request
    friend_request = FriendRequest.create(user_id: user.id, user_id_requested: -1)
    expect(friend_request).not_to be_valid
  end

  it "does not create a friend request when user and friend are the same" do
    # user 1
    theme = Theme.create(name: "a")
    section = Section.create(name: "a")
    Bundle.create(name: "a", theme_id: theme.id, section_id: section.id, active: 'y')
    user = User.create(email: "a@a.a", password: "aaabbb", username: "a")


    # friend
    friend_request = FriendRequest.create(user_id: user.id, user_id_requested: user.id)
    expect(friend_request).not_to be_valid
  end


  # USER PHOTO
  # Requirements:
  # <user>
  # profile_image: 'y' or 'n' (default 'n')
  it "can create a user photo" do
    # user
    theme = Theme.create(name: "a")
    section = Section.create(name: "a")
    Bundle.create(name: "a", theme_id: theme.id, section_id: section.id, active: 'y')
    user = User.create(email: "a@a.a", password: "aaabbb", username: "a")


    # user photo
    user_photo = UsersPhoto.create(user_id: user.id)
    expect(user_photo).to be_valid
  end


  # USER PROFILE
  # Requirements:
  # <user>
  it "can create a user profile" do
    # user
    theme = Theme.create(name: "a")
    section = Section.create(name: "a")
    Bundle.create(name: "a", theme_id: theme.id, section_id: section.id, active: 'y')
    user = User.create(email: "a@a.a", password: "aaabbb", username: "a")

    # To test creating a user profile, we need to delete the user
    # profile that gets created when a user record is created
    UsersProfile.find_by_user_id(user.id).delete


    # user profile
    user_profile = UsersProfile.create(user_id: user.id)
    expect(user_profile).to be_valid
  end


  # USER DESIGN
  # Requirements:
  # <user>, <design>, <location>
  # first_time_click: 'y' or 'n' (default 'y')
  # hide: 'y' or 'n'
  it "can create a user design" do
    # user
    theme = Theme.create(name: "a")
    section = Section.create(name: "a")
    Bundle.create(name: "a", theme_id: theme.id, section_id: section.id, active: 'y')
    user = User.create(email: "a@a.a", password: "aaabbb", username: "a")

    # design
    company = Company.create(name: "a")
    item = Item.create(name: "a", name_singular: "a")
    design = ItemsDesign.create(company_id: company.id, item_id: item.id, name: "a")

    # location
    section = Section.create(name: "a")
    location = Location.create(section_id: section.id, name: "a", height: 0, width: 0, x: 0, y: 0, z: 0)


    # user design
    user_design = UsersItemsDesign.create(user_id: user.id, items_design_id: design.id, location_id: location.id, hide: 'n')
    expect(user_design).to be_valid
  end


  # USER BOOKMARK
  # Requirements:


  # BUNDLE BOOKMARK



  # NOTIFICATION



  # USER NOTIFICAITON



  # STATIC CONTENT


end
