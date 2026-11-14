class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome_email.subject
  #
  def welcome_email
    @user = params[:user]
    mail(to: @user.email_address, subject: "Welcome")
  end
end
