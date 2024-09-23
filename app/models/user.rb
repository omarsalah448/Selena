class User < ApplicationRecord
  include Tokenable

  attr_accessor :activation_token

  belongs_to :company, optional: true
  accepts_nested_attributes_for :company
  has_secure_password

  before_validation :normalize_phone_number
  before_create -> { generate_token(:activation) }

  validates :name, presence: true, length: { minimum: 4, maximum: 20 }
  validates :email, presence: true, 
                    uniqueness: { scope: :activated, case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :title, presence: true, length: { minimum: 2, maximum: 50 }
  validates :phone_number, phone: true, presence: true
  validates :company_id, presence: true, unless: -> { company.present? }
  validates :password, length: { minimum: 6, maximum: 20 }, allow_blank: true, on: :update
  validates :password_confirmation, length: { minimum: 6, maximum: 20 }, allow_blank: true, on: :update

  def activate
    update!(activated: true, activated_at: Time.current)
  end

  has_many :device_tokens, dependent: :destroy
  has_many :vacations, dependent: :destroy

  private

  def normalize_phone_number
    self.phone_number = Phonelib.parse(phone_number).full_e164.presence
  end
end
