class UserMailer < ApplicationMailer
  def welcome_email
    @user = Data.define(:email).new("watanabe@example.com")
    @url  = "http://example.com/login"
    mail(to: @user.email,
         subject: "Welcome to My Awesome Site")
  end
end
