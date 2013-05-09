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
  attr_accessible :email,:name,:password,:password_confirmation,:username, :image_name

  has_secure_password


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  before_create :get_username
  after_create :create_user_notification, :send_signup_user_email



  validates :name,
             presence:true,
             #format: { with: VALID_USERNAME_REGEX},
             length: { maximum: 50 }
             #uniqueness:{ case_sensitive: false }

  validates :email,
             presence:true,
             format: { with: VALID_EMAIL_REGEX },
             uniqueness:{ case_sensitive: false }

  validate :password,
             presence:true,
             format:{minimum: 6}

  validate :password_confirmation,
             presence:true

  mount_uploader :image_name, UsersImageUploader

  has_many :users_themes
  has_many :users_items_designs
  has_many :users_bookmarks
  has_many :users_galleries
  has_many :friends

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end



    # Fix the username for the url
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
      random_number1 = rand(0..100000)
      random_number2 = rand(random_number1..100000)

      self.username = username_split+'-'+random_number1.to_s+"-"+random_number2.to_s

    end

    # create the user notification on the table
    def create_user_notification
      UsersNotification.create(user_id:self.id)
    end


    # Send email after the user sign up
    def send_signup_user_email

        UsersMailer.signup_email(self).deliver

    end



end

