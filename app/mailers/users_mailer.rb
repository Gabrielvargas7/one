class UsersMailer < ActionMailer::Base
  #default from: "from@example.com"
  default from: "mywebroom@mywebroom.com"
  #default bcc: "artem@mywebroom.com"


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.users_mailer.forget_password_email.subject
  #
  def forget_password_email(user)
    @user  = user
    @user_profile = UsersProfile.where("user_id = ?", user.id).first
    @greeting = "Hi, you forget password"

    mail to: @user.email,subject: "Help, MyWebRoom "
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.users_mailer.signup_email.subject
  #
  def signup_email(user)

    @user = user
    @greeting = "Hi"
    mail to: @user.email,subject: "Welcome to MyWebRoom"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.users_mailer.friend_request_email.subject
  #
  def friend_request_email(user ,user_requested)

    @user = user
    @user_requested = user_requested
    @user_photo  = UsersPhoto.where("profile_image = 'y' and user_id = ? ", user.id).first

    @user_profile = UsersProfile.where("user_id = ?", user.id).first
    @user_requested_profile = UsersProfile.where("user_id = ?", user_requested.id).first

    @user_photo.image_name
    @came_from_email_request_key = 'EMAIL_REQUEST_KEY'


    @greeting = "Hi, "+@user.username+" want to be your friend"

    mail to: @user_requested.email,subject: "A friend request from MyWebRoom"

  end
end
