class SearchesController < ApplicationController

  before_filter :json_signed_in_user,
                only:[
                    #:json_index_searches_items_themes_bundles_bookmarks_users_with_limit_and_offset_and_keyword

                ]

  before_filter :json_correct_user,
                only:[
                    #:json_index_searches_items_themes_bundles_bookmarks_users_with_limit_and_offset_and_keyword
                ]





  #***********************************
  # Json methods for the room users
  #***********************************

  # GET get search items,themes, bundles,bookmarks,users by the keyword with limit and offset
  # Limit is the number of returns by type that you want it
  # Offset is where you want to start
  # /searches/json/index_searches_items_themes_bundles_bookmarks_users_with_limit_and_offset_and_keyword/:limit/:offset/:keyword
  # /searches/json/index_searches_items_themes_bundles_bookmarks_users_with_limit_and_offset_and_keyword/10/0/gabriel var.json
  #Return head
  #success    ->  head  200 OK

  def json_index_searches_items_themes_bundles_bookmarks_users_with_limit_and_offset_and_keyword

    respond_to do |format|
      if params[:keyword]


        keyword = params[:keyword]
        keyword.downcase!

        array_keyword = keyword.split(' ')

        @users_array = []
        @users_profiles_array = []
        @themes_array = []
        @bundles_array = []
        @items_designs_array = []
        @bookmarks_array = []


        # Found all the id for every word
        # example: chair brown wood
        # find all the items,users,themes,bundles, bookmarks with that words
        array_keyword.each do |keyword|


          # limit the length of the string to avoid injection
          if keyword.length < 12

          @users_id_array = User.
              where("lower(users.username) LIKE ? ", "%#{keyword}%").
              limit(params[:limit]).
              offset(params[:offset]).
              pluck(:id)

          @users_array.concat(@users_id_array)


          @users_id_profiles = UsersProfile.
              where('lower(firstname) LIKE ? or lower(lastname) LIKE ?', "%#{keyword}%","%#{keyword}%").
              limit(params[:limit]).
              offset(params[:offset]).
              pluck(:user_id)

          @users_profiles_array.concat(@users_id_profiles)

          @themes_id_array = Theme.
              where('lower(name)      LIKE ? or
                           lower(category)  LIKE ? or
                           lower(style)     LIKE ? or
                           lower(brand)     LIKE ? or
                           lower(location)  LIKE ? or
                           lower(color)     LIKE ? or
                           lower(make)      LIKE ? or
                           lower(special_name)  LIKE ?',
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%").
              limit(params[:limit]).
              offset(params[:offset]).
              pluck(:id)


          @themes_array.concat(@themes_id_array)

          @bundles_id_array = Bundle.
              where('lower(name)      LIKE ? or
                           lower(category)  LIKE ? or
                           lower(style)     LIKE ? or
                           lower(brand)     LIKE ? or
                           lower(location)  LIKE ? or
                           lower(color)     LIKE ? or
                           lower(make)      LIKE ? or
                           lower(special_name)  LIKE ?',
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%").
              where("active = 'y'").
              limit(params[:limit]).
              offset(params[:offset]).
              pluck(:id)

          @bundles_array.concat(@bundles_id_array)

          @items_designs_id_array = ItemsDesign.
              where('lower(items_designs.name) LIKE ? or
                           lower(items.name)   LIKE ? or
                           lower(category)  LIKE ? or
                           lower(style)     LIKE ? or
                           lower(brand)     LIKE ? or
                           lower(color)     LIKE ? or
                           lower(make)      LIKE ? or
                           lower(special_name)  LIKE ?',
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%",
                    "%#{keyword}%").
              joins(:item).
              limit(params[:limit]).
              offset(params[:offset]).
              pluck(:id)

          @items_designs_array.concat(@items_designs_id_array)

          @bookmarks_id_array = Bookmark.
              where('lower(title) LIKE ? or
                     lower(name)   LIKE ?',
                    "%#{keyword}%",
                    "%#{keyword}%").
              joins(:bookmarks_category).
              limit(params[:limit]).
              offset(params[:offset]).
              pluck(:id)
          @bookmarks_array.concat(@bookmarks_id_array)


          end
        end

        # get all user from users_array
        @users = UsersPhoto.
            select('users.username,
                    users_photos.image_name,
                    users_photos.user_id').
            joins(:user).
            where("user_id in (?)", @users_array).
            where("profile_image = 'y'").
            limit(params[:limit]).
            offset(params[:offset])

        #get all the profile from users_profiles_array
        @users_profiles = UsersPhoto.
            select('users_photos.image_name,
                          users_photos.user_id,
                          users_profiles.firstname,
                          users_profiles.lastname').
            joins('LEFT OUTER JOIN users_profiles  ON users_profiles.user_id = users_photos.user_id').
            where('users_profiles.user_id in (?)',@users_profiles_array).
            where(" profile_image = 'y' ").
            limit(params[:limit]).
            offset(params[:offset])

        @themes = Theme.
                  where('id in (?)',@themes_array).
                    limit(params[:limit]).
                    offset(params[:offset])

        @bundles = Bundle.
                where('id in (?)',@bundles_array).
                limit(params[:limit]).
                offset(params[:offset])

        @items_designs = ItemsDesign.
            select('items_designs.id,
                            items_designs.name,
                            items_designs.item_id,
                            items_designs.description,
                            items_designs.category,
                            items_designs.style,
                            items_designs.brand,
                            items_designs.color,
                            items_designs.make,
                            items_designs.special_name,
                            items_designs.like,
                            items_designs.image_name,
                            items.name as items_name').
            where('items_designs.id in (?)',@items_designs_array).
            joins(:item).
            limit(params[:limit]).
            offset(params[:offset])


        @bookmarks = Bookmark.
            select('bookmarks.id,
                    name as bookmarks_category_name,
                    bookmarks_category_id,
                    title,
                    image_name,
                    image_name_desc,
                    bookmark_url,
                    bookmarks.like,
                    description'

            ).
            where('bookmarks.id in (?)',@bookmarks_array).
            joins(:bookmarks_category).
            limit(params[:limit]).
            offset(params[:offset])


        format.json { render json:{
                                    #items_designs_array:@items_designs_array,
                                    items_designs:@items_designs,
                                    #users_array:@users_array,
                                    users:@users,
                                    #users_profiles_array:@users_profiles_array,
                                    users_profiles:@users_profiles,
                                    #themes_array:@themes_array,
                                    themes:@themes,
                                    #bundle_array:@bundles_array,
                                    bundles:@bundles,
                                    #bookmark_array:@bookmarks_array,
                                    bookmarks:@bookmarks
        }}

      else
        @user = nil
        format.json { render json: @user }
      end
    end
  end




  # GET get search users profile by the keyword with limit and offset
  # Limit is the number of returns by type that you want it
  # Offset is where you want to start
  # /searches/json/index_searches_users_profile_with_limit_and_offset_and_keyword/:limit/:offset/:keyword
  # /searches/json/index_searches_users_profile_with_limit_and_offset_and_keyword/10/0/gabriel var.json
  #Return head
  #success    ->  head  200 OK

  def json_index_searches_users_profile_with_limit_and_offset_and_keyword

    respond_to do |format|
      if params[:keyword]


        keyword = params[:keyword]
        keyword.downcase!

        array_keyword = keyword.split(' ')

        @users_profiles_array = []


        # Found all the id for every word
        # example: chair brown wood
        # find all the users with that words
        array_keyword.each do |keyword|


          # limit the length of the string to avoid injection
          if keyword.length < 12

            @users_id_profiles = UsersProfile.joins(:user).
                where('lower(firstname) LIKE ? or lower(lastname) LIKE ? or lower(users.username) LIKE ?', "%#{keyword}%","%#{keyword}%","%#{keyword}%").
                limit(params[:limit]).
                offset(params[:offset]).
                pluck(:user_id)

            @users_profiles_array.concat(@users_id_profiles)
          end
        end

        @users_profiles = UsersPhoto.
                  select('users_photos.image_name,
                          users_photos.user_id,
                          users_profiles.firstname,
                          users_profiles.lastname,
                          users.username
                  ').
                  joins(:user).
                  joins('LEFT OUTER JOIN users_profiles  ON users_profiles.user_id = users_photos.user_id').
                  where('users_profiles.user_id in (?)',@users_profiles_array).
                  where(" users_photos.profile_image = 'y' ").
                  limit(params[:limit]).
                  offset(params[:offset])


        format.json { render json:@users_profiles
        }

      else
        @user = nil
        format.json { render json: @users_profiles }
      end
    end
  end




  # GET get search items designs by the keyword with limit and offset
# Limit is the number of returns by type that you want it
# Offset is where you want to start
# /searches/json/index_searches_items_designs_with_limit_and_offset_and_keyword/:limit/:offset/:keyword
# /searches/json/index_searches_items_designs_with_limit_and_offset_and_keyword/10/0/gabriel var.json
#Return head
#success    ->  head  200 OK

  def json_index_searches_items_designs_with_limit_and_offset_and_keyword

    respond_to do |format|
      if params[:keyword]


        keyword = params[:keyword]
        keyword.downcase!

        array_keyword = keyword.split(' ')

        @items_designs_array = []

        # Found all the id for every word
        # example: chair brown wood
        # find all the users with that words
        array_keyword.each do |keyword|

          # limit the length of the string to avoid injection
          if keyword.length < 12

            @items_designs_id_array = ItemsDesign.
                where('lower(items_designs.name) LIKE ? or
                           lower(items.name)   LIKE ? or
                           lower(category)  LIKE ? or
                           lower(style)     LIKE ? or
                           lower(brand)     LIKE ? or
                           lower(color)     LIKE ? or
                           lower(make)      LIKE ? or
                           lower(special_name)  LIKE ?',
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%").
                joins(:item).
                limit(params[:limit]).
                offset(params[:offset]).
                pluck(:id)

            @items_designs_array.concat(@items_designs_id_array)




          end
        end

        @items_designs = ItemsDesign.
            select('items_designs.id,
                            items_designs.name,
                            items_designs.item_id,
                            items_designs.description,
                            items_designs.category,
                            items_designs.style,
                            items_designs.brand,
                            items_designs.color,
                            items_designs.make,
                            items_designs.special_name,
                            items_designs.like,
                            items_designs.image_name,
                            items_designs.image_name_hover,
                            items_designs.image_name_selection,
                            items.name as items_name').
            where('items_designs.id in (?)',@items_designs_array).
            joins(:item).
            limit(params[:limit]).
            offset(params[:offset])

        format.json { render json:@items_designs
        }

      else
        @items_designs = nil
        format.json { render json: @items_designs }
      end
    end
  end



  # GET get search themes by the keyword with limit and offset
  # Limit is the number of returns by type that you want it
  # Offset is where you want to start
  # /searches/json/index_searches_themes_with_limit_and_offset_and_keyword/:limit/:offset/:keyword
  # /searches/json/index_searches_themes_with_limit_and_offset_and_keyword/10/0/blu.json
  #Return head
  #success    ->  head  200 OK

  def json_index_searches_themes_with_limit_and_offset_and_keyword

    respond_to do |format|
      if params[:keyword]


        keyword = params[:keyword]
        keyword.downcase!

        array_keyword = keyword.split(' ')

        @themes_array = []

        # Found all the id for every word
        # example: chair brown wood
        # find all the users with that words
        array_keyword.each do |keyword|

          # limit the length of the string to avoid injection
          if keyword.length < 12

            @themes_id_array = Theme.
                where('lower(name)      LIKE ? or
                           lower(category)  LIKE ? or
                           lower(style)     LIKE ? or
                           lower(brand)     LIKE ? or
                           lower(location)  LIKE ? or
                           lower(color)     LIKE ? or
                           lower(make)      LIKE ? or
                           lower(special_name)  LIKE ?',
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%").
                limit(params[:limit]).
                offset(params[:offset]).
                pluck(:id)

            @themes_array.concat(@themes_id_array)

          end
        end

        @themes = Theme.
            where('id in (?)',@themes_array).
            limit(params[:limit]).
            offset(params[:offset])

        format.json { render json:@themes
        }

      else
        @themes = nil
        format.json { render json: @themes }
      end
    end
  end



  # GET get search bundles by the keyword with limit and offset
  # Limit is the number of returns by type that you want it
  # Offset is where you want to start
  # /searches/json/index_searches_bundles_with_limit_and_offset_and_keyword/:limit/:offset/:keyword
  # /searches/json/index_searches_bundles_with_limit_and_offset_and_keyword/10/0/blu.json
  #Return head
  #success    ->  head  200 OK

  def json_index_searches_bundles_with_limit_and_offset_and_keyword

    respond_to do |format|
      if params[:keyword]


        keyword = params[:keyword]
        keyword.downcase!

        array_keyword = keyword.split(' ')

        @bundles_array = []

        # Found all the id for every word
        # example: chair brown wood
        # find all the users with that words
        array_keyword.each do |keyword|

          # limit the length of the string to avoid injection
          if keyword.length < 12

            @bundles_id_array = Bundle.
                where('lower(name)      LIKE ? or
                           lower(category)  LIKE ? or
                           lower(style)     LIKE ? or
                           lower(brand)     LIKE ? or
                           lower(location)  LIKE ? or
                           lower(color)     LIKE ? or
                           lower(make)      LIKE ? or
                           lower(special_name)  LIKE ?',
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%").
                where("active = 'y'").
                limit(params[:limit]).
                offset(params[:offset]).
                pluck(:id)
            @bundles_array.concat(@bundles_id_array)
          end
        end

        @bundles = Bundle.
            where('id in (?)',@bundles_array).
            limit(params[:limit]).
            offset(params[:offset])


        format.json { render json:@bundles
        }

      else
        @bundles = nil
        format.json { render json: @bundles }
      end
    end
  end



  # GET get search bookmarks by the keyword with limit and offset
  # Limit is the number of returns by type that you want it
  # Offset is where you want to start
  # /searches/json/index_searches_bookmarks_with_limit_and_offset_and_keyword/:limit/:offset/:keyword
  # /searches/json/index_searches_bookmarks_with_limit_and_offset_and_keyword/10/0/blu.json
  #Return head
  #success    ->  head  200 OK

  def json_index_searches_bookmarks_with_limit_and_offset_and_keyword

    respond_to do |format|
      if params[:keyword]


        keyword = params[:keyword]
        keyword.downcase!

        array_keyword = keyword.split(' ')

        @bookmarks_array = []

        # Found all the id for every word
        # example: chair brown wood
        # find all the users with that words
        array_keyword.each do |keyword|

          # limit the length of the string to avoid injection
          if keyword.length < 12

            @bookmarks_id_array = Bookmark.
                where('lower(title) LIKE ? or
                     lower(name)   LIKE ?',
                      "%#{keyword}%",
                      "%#{keyword}%").
                joins(:bookmarks_category).
                limit(params[:limit]).
                offset(params[:offset]).
                pluck(:id)
            @bookmarks_array.concat(@bookmarks_id_array)


          end
        end

        @bookmarks = Bookmark.
            select('bookmarks.id,
                    name as bookmarks_category_name,
                    bookmarks_category_id,
                    title,
                    image_name,
                    image_name_desc,
                    bookmark_url,
                    bookmarks.like,
                    description'

        ).
            where('bookmarks.id in (?)',@bookmarks_array).
            joins(:bookmarks_category).
            limit(params[:limit]).
            offset(params[:offset])



        format.json { render json:@bookmarks}

      else
        @bookmarks = nil
        format.json { render json: @bookmarks }
      end
    end
  end


  # GET get search items designs by item_id and the keyword with limit and offset
  # Limit is the number of returns by type that you want it
  # Offset is where you want to start
  # /searches/json/index_searches_items_designs_with_item_id_and_limit_and_offset_and_keyword/item_id/:limit/:offset/:keyword
  # /searches/json/index_searches_items_designs_with_item_id_and_limit_and_offset_and_keyword/10/10/0/gabriel var.json
  #Return head
  #success    ->  head  200 OK

  def json_index_searches_items_designs_with_item_id_and_limit_and_offset_and_keyword

    respond_to do |format|
      if params[:keyword]


        keyword = params[:keyword]
        keyword.downcase!

        array_keyword = keyword.split(' ')

        @items_designs_array = []

        # Found all the id for every word
        # example: chair brown wood
        # find all the users with that words
        array_keyword.each do |keyword|

          # limit the length of the string to avoid injection
          if keyword.length < 12

            @items_designs_id_array = ItemsDesign.
                where('lower(items_designs.name) LIKE ? or
                           lower(items.name)   LIKE ? or
                           lower(category)  LIKE ? or
                           lower(style)     LIKE ? or
                           lower(brand)     LIKE ? or
                           lower(color)     LIKE ? or
                           lower(make)      LIKE ? or
                           lower(special_name)  LIKE ?',
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%",
                      "%#{keyword}%").
                where('item_id = ?',params[:item_id]).
                joins(:item).
                limit(params[:limit]).
                offset(params[:offset]).
                pluck(:id)

            @items_designs_array.concat(@items_designs_id_array)


          end
        end

        @items_designs = ItemsDesign.
            select('items_designs.id,
                            items_designs.name,
                            items_designs.item_id,
                            items_designs.description,
                            items_designs.category,
                            items_designs.style,
                            items_designs.brand,
                            items_designs.color,
                            items_designs.make,
                            items_designs.special_name,
                            items_designs.like,
                            items_designs.image_name,
                            items.name as items_name').
            where('items_designs.id in (?)',@items_designs_array).
            where('item_id = ?',params[:item_id]).
            joins(:item).
            limit(params[:limit]).
            offset(params[:offset])

        format.json { render json:@items_designs
        }

      else
        @items_designs = nil
        format.json { render json: @items_designs }
      end
    end
  end






end
