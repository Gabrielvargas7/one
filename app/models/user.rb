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
  attr_accessible :email,:name,:password,:username, :image_name ,:provider,:uid

  has_many :users_themes
  has_many :users_items_designs
  has_many :users_bookmarks
  has_many :users_galleries
  has_many :friends
  has_many :friend_requests
  has_many :users_notifications

  has_secure_password



  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { |user| user.email = email.downcase }

  before_save :create_remember_token
  before_create :get_username

  after_create :create_user_notification, :send_signup_user_email ,:create_random_room


  validates :name,
             presence:true,
             length: { maximum: 50 }
             #uniqueness:{ case_sensitive: false }

  validates :email,
             presence:true,
             format: { with: VALID_EMAIL_REGEX },
             uniqueness:{ case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }



  mount_uploader :image_name, UsersImageUploader


  # Send email after the user sign up
  def send_signup_user_email
    UsersMailer.signup_email(self).deliver
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UsersMailer.forget_password_email(self).deliver

  end

  # create(facebook.. )the user if don't exist
  def self.from_omniauth(auth)

    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|

      # create a fake password for the facebook users
      fake_password = SecureRandom.urlsafe_base64

      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.remember_token = auth.credentials.token
      user.image_name = auth.info.image
      user.email = auth.extra.raw_info.email

      user.password = fake_password
      user.password_confirmation = fake_password
      user.save!
    end
  end

  # create the username for the url
  def get_username

    my_username = name
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

    #use this method when the user forget the password
    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end


    def create_remember_token
      # when the user authenticate with facebook
      # we don't create a token
      if self.uid.blank?
         self.remember_token = SecureRandom.urlsafe_base64
      end
    end


    # create the user notification on the table  when the user sign-up
    def create_user_notification
      UsersNotification.create(user_id:self.id,notified:'y')
    end

    #this is temp until the new design
    def create_random_room

      bundle_max = Bundle.maximum("id")
      bundle_min = Bundle.minimum("id")
      #print "bundle max "+bundle_max.to_s
      bundle_rand_number = rand(bundle_min..bundle_max)
      #print "bundle_rand_number  "+bundle_rand_number.to_s
      bundle = Bundle.find(bundle_rand_number)

      #create the theme from the bundle
      UsersTheme.create!(user_id:self.id,theme_id:bundle.theme_id)


      #create the items_design from the bundle
      @items_designs = ItemsDesign.find_all_by_bundle_id(bundle.id)
      @items_designs.each  do |items_design|
        UsersItemsDesign.create!(user_id:self.id,items_design_id:items_design.id,hide:'no')
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

