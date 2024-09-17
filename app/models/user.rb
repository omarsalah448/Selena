class User < ApplicationRecord
  belongs_to :company, optional: true
  accepts_nested_attributes_for :company
  has_secure_password

  validates :name, presence: true, length: { in: 2..40 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :title, presence: true, length: { in: 2..20 }
  validates :phone_number, presence: true, length: { in: 4..20 }
  validates :company_id, presence: true, unless: -> { company.present? }

  enum role: { user: 0, admin: 1 }
end