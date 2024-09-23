class SendEmailsJob < ApplicationJob
  queue_as :default

  def perform(user, token)
    UserMailer.activation_email(user, token).deliver_later
  end
end
