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
    @greeting = "Hi, you forget password"

    mail to: @user.email,subject: "mywebroom help"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.users_mailer.signup_email.subject
  #
  def signup_email(user)

    @user = user


    @greeting = "Hi"

    mail to: @user.email,subject: "Welcome to mywebroom"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.users_mailer.friend_request_email.subject
  #
  def friend_request_email(user)
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
