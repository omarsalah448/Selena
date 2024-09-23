class InviteUser
  def initialize(**params)
    @invite_params = params[:invite_params]
    @current_user = params[:current_user]
  end

  def call
    User.transaction do
      check_existing_user
      create_user
      send_activation_email
    end
    @user
  end
  private

  def check_existing_user
    existing_user = User.find_by(email: @invite_params[:email], activated: true)
    raise "This email already exists" if existing_user.present?
  end

  def create_user
    raise "Please login to invite user" unless @current_user.present?
    password = SecureRandom.hex(8)
    @user = User.create!(@invite_params.merge(
      password: password,
      password_confirmation: password,
      company_id: @current_user.company_id
    ))
  end

  def send_activation_email
    SendEmailsJob.perform_now(@user, @user.activation_token)
    @user.update(activation_sent_at: Time.current)
  end
end
