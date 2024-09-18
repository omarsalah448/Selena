class User < ApplicationRecord
  belongs_to :company, optional: true
  accepts_nested_attributes_for :company
  has_secure_password

  validates :name, presence: true, length: { minimum: 4, maximum: 20 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :title, presence: true, length: { minimum: 2, maximum: 50 }
  validates :phone_number, phone: true, presence: true
  validates :company_id, presence: true, unless: -> { company.present? }
  validates :password, length: { minimum: 6, maximum: 20 }
  validates :password_confirmation, length: { minimum: 6, maximum: 20 }

  enum role: { user: 0, admin: 1 }

  before_validation :normalize_phone_number

  private

  def normalize_phone_number
    self.phone_number = Phonelib.parse(phone_number).full_e164.presence
  end
end