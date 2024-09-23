FactoryBot.define do
  factory :device_token do
    user
    device_id { SecureRandom.uuid }
    # token is generated automatically by the model
  end
end