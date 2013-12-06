# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#  username        :string(255)
#  image_name      :string(255)
#
require 'open-uri'

class User < ActiveRecord::Base
  attr_accessible :email,:password,:username ,:provider,:uid


  attr_accessor :specific_room_id

  #mount_uploader :image_name, UsersImageUploader

  has_many :users_themes
  has_many :users_items_designs
  has_many :users_bookmarks
  has_many :friends
  has_many :friend_requests
  has_many :users_notifications
  has_many :users_photos
  has_many :users_profiles

  has_secure_password


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { |user| user.email = email.downcase }


  before_save :create_remember_token
  before_create{ get_username(self.email)}

  after_create :create_user_notification,
               :send_signup_user_email,
               #:create_random_room,
               :create_specific_room,
               :create_image_name,
               :create_user_profile,
               :create_specific_friends


  #validates :name,
  #           presence:true,
  #           length: { maximum: 50 }


  validates :email,
             presence:true,
             format: { with: VALID_EMAIL_REGEX },
             uniqueness:{ case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }, :if => :password

  validates :username, uniqueness:{ case_sensitive: false }





#***********************************
# user  send_signup_user_email
#***********************************

  # Send email after the user sign up
  def send_signup_user_email
    #if Rails.env.production?
    #    UsersMailer.signup_email(self).deliver
    #end
  end

  #***********************************
  # user  send_password_reset
  #***********************************

  def send_password_reset
    #generate_token(:password_reset_token)
    #self.password_reset_sent_at = Time.zone.now
    ##save!
    #save!(validate: false)
    #UsersMailer.forget_password_email(self).deliver

  end

  #***********************************
  # user  self.from_omniauth(auth)
  #***********************************

  # create(facebook.. )the user if don't exist
  def self.from_omniauth(auth,specific_room_id)

    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|

      # create a fake password for the facebook users
      fake_password = SecureRandom.urlsafe_base64

      #---------------------------------
      # create user from facebook
      #---------------------------------

      #puts "omniauth cookies facebook"+cookies[:facebook_bundle_id].to_s
      #
      #if cookies[:facebook_bundle_id].nil?
      #
      #else
      user.specific_room_id = specific_room_id
      #end


      user.provider = auth.provider
      user.uid = auth.uid
      user.remember_token = auth.credentials.token
      user.email = auth.extra.raw_info.email
      user.password = fake_password
      user.password_confirmation = fake_password
      user.save!


      #---------------------------------
      # create user profile from facebook
      #---------------------------------

      if UsersProfile.exists?(user_id:user.id)
        user_profile  = UsersProfile.find_by_user_id(user.id)
      else
        # we add this new profile with facebook sign up and
        # add the tutorial step and friend number because user don't do it with save!
        user_profile  = UsersProfile.new()

        user_profile.tutorial_step = 1
        user_profile.friends_number = 7

      end
      user_profile.firstname = auth.extra.raw_info.first_name
      user_profile.lastname = auth.extra.raw_info.last_name
      user_profile.gender = auth.extra.raw_info.gender
      user_profile.birthday = auth.info.user_birthday
      user_profile.user_id = user.id
      user_profile.save!

      #---------------------------------
      # create user profile photo from facebook
      #---------------------------------

      unless UsersPhoto.exists?(user_id:user.id,profile_image:'y')
        user_photo  = UsersPhoto.new()
        puts "new photo field"

        user_image_name = user.id.to_s
        user_image_name = rand(0..100000).to_s+user_image_name+".jpg"
        #facebook_image = "#{Rails.root}/tmp/uploads/cache/facebook/"+user_image_name
        facebook_image = "#{Rails.root}/tmp/"+user_image_name

        open(facebook_image, 'wb') do |file|
          #file << open(auth.info.image).read
          #file << open( auth.info.image.split("=")[0]<< "=normal").read
          file << open( auth.info.image.split("=")[0]<< "=large").read
        end

        if File.exists?(facebook_image)
          puts "file exist yes"
          user_photo.image_name = File.open(facebook_image)
        end
        user_photo.user_id = user.id
        user_photo.profile_image = 'y'
        user_photo.save!

      end

    end
  end

  #***********************************
  # user  get_username(new_username)
  #***********************************

  # create the username for the url
  def get_username(new_username)

    my_username_no_email = new_username.split('@')

    my_username = my_username_no_email.first
    #my_username = new_username
    #remove all non- alphanumeric character (expect dashes '-')
    my_username = my_username.gsub(/[^0-9a-z -]/i, '')

    #remplace dashes() for empty space because if the user add dash mean that it want separate the username
    my_username = my_username.gsub(/[-]/i, ' ')

    #remplace the empty space for one dash by word
    my_username.downcase!
    my_username.strip!
    username_split = my_username.split(' ').join('-')

          #get random number for the user
          #random_number1 = rand(0..100000)
          #random_number2 = rand(random_number1..100000)
          #unique_username = username_split+'-'+random_number1.to_s+"-"+random_number2.to_s

    unique_username = username_split
    random_number1 = 0
    random_number2 = 100
    while User.exists?(username:unique_username)

      print "not duplicate username: "+unique_username.to_s
      #get random number for the user
      random_number1 = rand(random_number1..random_number2)
      random_number2 = rand(random_number2..random_number2+100)
      unique_username = username_split+'-'+random_number1.to_s+"-"+random_number2.to_s
    end

    self.username = unique_username

  end

  private


  #***********************************
  # user  generate_token(column)
  #***********************************

  #use this method when the user forget the password
    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end


    def create_remember_token
      # when the user authenticate with facebook
      # we don't create a token because facebook generate it for us
      if self.uid.blank?
         self.remember_token = SecureRandom.urlsafe_base64
      end
    end


  #***********************************
  # user  create_user_notification
  #***********************************

  # create the user notification on the table  when the user sign-up
    def create_user_notification

      if Notification.count.zero?
        # if notification is we need to create one

        UsersNotification.create(user_id:self.id,notified:'y')


      else
        notification = Notification.last
        UsersNotification.create(user_id:self.id,notified:'y',notification_id:notification.id)
      end




    end

  #***********************************
  # user  create_specific_friends
  #***********************************

  # create the user notification on the table  when the user sign-up
  def create_specific_friends
    @friend_id = 28  # gabriel
    if User.exists?(id:@friend_id)
      Friend.create(user_id:@friend_id,user_id_friend:self.id)
      Friend.create(user_id:self.id,user_id_friend:@friend_id)
    end

    @friend_id = 25  # John
    if User.exists?(id:@friend_id)
      Friend.create(user_id:@friend_id,user_id_friend:self.id)
      Friend.create(user_id:self.id,user_id_friend:@friend_id)
    end

    @friend_id = 24  # Sara
    if User.exists?(id:@friend_id)
      Friend.create(user_id:@friend_id,user_id_friend:self.id)
      Friend.create(user_id:self.id,user_id_friend:@friend_id)
    end


    @friend_id = 29  # aubrey
    if User.exists?(id:@friend_id)
      Friend.create(user_id:@friend_id,user_id_friend:self.id)
      Friend.create(user_id:self.id,user_id_friend:@friend_id)
    end


    @friend_id = 26  #artem
    if User.exists?(id:@friend_id)
      Friend.create(user_id:@friend_id,user_id_friend:self.id)
      Friend.create(user_id:self.id,user_id_friend:@friend_id)
    end

    @friend_id = 32  #millu
    if User.exists?(id:@friend_id)
      Friend.create(user_id:@friend_id,user_id_friend:self.id)
      Friend.create(user_id:self.id,user_id_friend:@friend_id)
    end
    @friend_id = 34  #marketing
    if User.exists?(id:@friend_id)
      Friend.create(user_id:@friend_id,user_id_friend:self.id)
      Friend.create(user_id:self.id,user_id_friend:@friend_id)
    end

  end

  #***********************************
  # user  create_image_name
  #***********************************

  def create_image_name
    if self.uid.blank?
      UsersPhoto.create(user_id:self.id,profile_image:'y')
     end

  end

  #***********************************
  # user  create_user_profile
  #***********************************
  def create_user_profile
    if self.uid.blank?
      UsersProfile.create(user_id:self.id,tutorial_step:1)
    end
  end



  #***********************************
  # user  create_random_room
  #***********************************

  #this is temp until the new design
    def create_random_room

      bundle = Bundle.where("active = 'y'").order("RANDOM()").first

      #create the theme from the bundle
      UsersTheme.create!(user_id:self.id,theme_id:bundle.theme_id,section_id:bundle.section_id)

      #create the items_design from the bundle

      @bundles_items_designs = BundlesItemsDesign.find_all_by_bundle_id(bundle.id)
      @bundles_items_designs.each  do |bundles_items_design|
        UsersItemsDesign.create!(user_id:self.id,items_design_id:bundles_items_design.items_design_id,hide:'no',location_id:bundles_items_design.location_id)
      end

      #create the initials bookmarks from the bundle
      #@bundle_bookmarks = BundlesBookmark.all
      #@bundle_bookmarks.each do |bundle_bookmark|
      #  position = 1
      #
      #  while UsersBookmark.exists?(position:position,user_id:self.id,bookmark_id:bundle_bookmark.bookmark_id)
      #    position += position
      #  end
      #  #puts "final position" +position.to_s
      #  UsersBookmark.create!(user_id:self.id,bookmark_id:bundle_bookmark.bookmark_id,position:position)
      #end


      @items = Item.all
      @bundle_bookmarks = BundlesBookmark.all

      @items.each do |item|
        position = 1
        if BundlesBookmark.
          joins(:bookmark).
          joins('inner join bookmarks_categories ON bookmarks_categories.id = bookmarks.bookmarks_category_id').
          where('bookmarks_categories.item_id = ?',item.id).exists?


          @bundle_bookmarks = BundlesBookmark.
                              joins(:bookmark).
                              joins('inner join bookmarks_categories ON bookmarks_categories.id = bookmarks.bookmarks_category_id').
                              where('bookmarks_categories.item_id = ?',item.id)


          @bundle_bookmarks.each do |bundle_bookmark|
            UsersBookmark.create!(user_id:self.id,bookmark_id:bundle_bookmark.bookmark_id,position:position)
            position = position+1
          end
        end
      end


    end

  #***********************************
  # user  create_specific_room
  #***********************************


  def create_specific_room
    puts "inside of the specific room"

    if self.specific_room_id.nil?
      puts "specific_room_id is nil"

      if Bundle.exists?(id:27)
        bundle = Bundle.find(27)
      else
        bundle = Bundle.where("active = 'y'").order("RANDOM()").first
      end

    else
      puts "specific_room_id is not nil"
      if Bundle.exists?(id:self.specific_room_id)
        bundle = Bundle.find(self.specific_room_id)
      else
        bundle = Bundle.where("active = 'y'").order("RANDOM()").first
      end

    end

    #puts "final position"
    #if Bundle.exists?(id:6)
    #  bundle = Bundle.find(6)
    #else
    #  bundle = Bundle.where("active = 'y'").order("RANDOM()").first
    #end
    #create the theme from the bundle
    UsersTheme.create!(user_id:self.id,theme_id:bundle.theme_id,section_id:bundle.section_id)

    #create the items_design from the bundle

    @bundles_items_designs = BundlesItemsDesign.find_all_by_bundle_id(bundle.id)
    @bundles_items_designs.each  do |bundles_items_design|
      UsersItemsDesign.create!(user_id:self.id,items_design_id:bundles_items_design.items_design_id,hide:'no',location_id:bundles_items_design.location_id)
    end

    #create the initials bookmarks from the bundle
    #@items = Item.all
    #@bundle_bookmarks = BundlesBookmark.all
    #
    #@items.each do |item|
    #  position = 1
    #  if BundlesBookmark.exists?(item_id:item.id)
    #    @bundle_bookmarks = BundlesBookmark.where(item_id:item.id)
    #    @bundle_bookmarks.each do |bundle_bookmark|
    #      UsersBookmark.create!(user_id:self.id,bookmark_id:bundle_bookmark.bookmark_id,position:position)
    #      position = position+1
    #    end
    #  end
    #end

    @items = Item.all
    @bundle_bookmarks = BundlesBookmark.all

    @items.each do |item|
      position = 1
      if BundlesBookmark.
          joins(:bookmark).
          joins('inner join bookmarks_categories ON bookmarks_categories.id = bookmarks.bookmarks_category_id').
          where('bookmarks_categories.item_id = ?',item.id).exists?


        @bundle_bookmarks = BundlesBookmark.
            joins(:bookmark).
            joins('inner join bookmarks_categories ON bookmarks_categories.id = bookmarks.bookmarks_category_id').
            where('bookmarks_categories.item_id = ?',item.id)


        @bundle_bookmarks.each do |bundle_bookmark|
          UsersBookmark.create!(user_id:self.id,bookmark_id:bundle_bookmark.bookmark_id,position:position)
          position = position+1
        end
      end
    end



  end



end

