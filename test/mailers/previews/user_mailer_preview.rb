# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    user = Data.define(:email).new("watanabe@example.com")
    UserMailer.with(user:).welcome_email
  end
end
