# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.with(user: { id: 1, email: "watanabe@example.com" }).welcome_email
  end
end
