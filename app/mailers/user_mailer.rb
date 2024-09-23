class UserMailer < ApplicationMailer
  def activation_email(user, activation_token)
    @user = user
    @activation_token = activation_token
    @activation_url = "http://localhost:3000/account_activations/#{activation_token}/edit"
    mail(to: @user.email, subject: "Activate your account")
  end
end
