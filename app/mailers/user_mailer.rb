class UserMailer < ApplicationMailer
  before_action { @notexist = params[:notexist] } # 存在しないhashにアクセスしてもエラーにならない

  def welcome_email
    @user = params[:user]
    @url  = "http://example.com/login"
    # @notexist.not_exist_method # これは流石にエラーになる
    mail(to: @user.email,
         subject: "Welcome to My Awesome Site")
  end
end
