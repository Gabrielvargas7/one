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

class User < ActiveRecord::Base
  attr_accessible :email,:password,:username ,:provider,:uid

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

  after_create :create_user_notification, :send_signup_user_email ,:create_random_room,:create_image_name,:create_user_profile


  #validates :name,
  #           presence:true,
  #           length: { maximum: 50 }


  validates :email,
             presence:true,
             format: { with: VALID_EMAIL_REGEX },
             uniqueness:{ case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }

  validates :username, uniqueness:{ case_sensitive: false }





#***********************************
# user  send_signup_user_email
#***********************************

  # Send email after the user sign up
  def send_signup_user_email
    UsersMailer.signup_email(self).deliver
  end

  #***********************************
  # user  send_password_reset
  #***********************************

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UsersMailer.forget_password_email(self).deliver

  end

  #***********************************
  # user  self.from_omniauth(auth)
  #***********************************


  # create(facebook.. )the user if don't exist
  def self.from_omniauth(auth)

    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|

      # create a fake password for the facebook users
      fake_password = SecureRandom.urlsafe_base64

      user.provider = auth.provider
      user.uid = auth.uid
      user.remember_token = auth.credentials.token
      user.email = auth.extra.raw_info.email
      user.password = fake_password
      user.password_confirmation = fake_password
      user.save!

      # create user profile
      user_profile  = UsersProfile.new()
      user_profile.firstname = auth.extra.raw_info.first_name
      user_profile.lastname = auth.extra.raw_info.last_name
      user_profile.gender = auth.extra.raw_info.gender
      user_profile.birthday = auth.info.user_birthday
      user_profile.user_id = user.id
      user_profile.save!


      #open('image.png', 'wb') do |file|
      #  file << open('http://example.com/image.png').read
      #end
      # create new user photo
      user_photos = UsersPhoto.new()
      user_photos.user_id = user.id
      user_photos.profile_image = 'y'
      #user_photos.image_name = auth.info.image
      #user_photos.image_name = File.open(auth.info.image)
      user_photos.image_name = URI.parse(auth.info.image)
      user_photos.save!


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
      UsersNotification.create(user_id:self.id,notified:'y')
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
      UsersProfile.create(user_id:self.id)
    end
  end



  #***********************************
  # user  create_random_room
  #***********************************

  #this is temp until the new design
    def create_random_room

      #bundle_max = Bundle.maximum("id")

      # note this is a quick fix,
      # you should add the activation field for bundle
      # so the activation field will be say if the bundle is ready for use (it have all the values links for a bundle )
      # example, it have
      #        BundlesItemsDesign
      #        BundlesBookmark
      #        Theme
      #        Section .. more



      #bundle_min = Bundle.minimum("id")
      #
      #Bundle.where("active = 'y'").order("by RANDOM()").first
      #
      ##print "bundle max "+bundle_max.to_s
      #bundle_rand_number = rand(bundle_min..bundle_max)
      ##print "bundle_rand_number  "+bundle_rand_number.to_s
      #bundle = Bundle.find(bundle_rand_number)

      bundle = Bundle.where("active = 'y'").order("RANDOM()").first

      #create the theme from the bundle
      UsersTheme.create!(user_id:self.id,theme_id:bundle.theme_id,section_id:bundle.section_id)

      #create the items_design from the bundle

      @bundles_items_designs = BundlesItemsDesign.find_all_by_bundle_id(bundle.id)
      @bundles_items_designs.each  do |bundles_items_design|
        UsersItemsDesign.create!(user_id:self.id,items_design_id:bundles_items_design.items_design_id,hide:'no',location_id:bundles_items_design.location_id)
      end

      #create the initials bookmarks from the bundle
      @bundle_bookmarks = BundlesBookmark.all
      @bundle_bookmarks.each do |bundle_bookmark|
        position = 1
        while UsersBookmark.exists?(position:position,user_id:self.id,bookmark_id:bundle_bookmark.bookmark_id)
           position += position
        end
          UsersBookmark.create!(user_id:self.id,bookmark_id:bundle_bookmark.bookmark_id,position:position)
      end



    end



end

