class Company < ApplicationRecord
  has_many :users

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :timezone, presence: true,
              inclusion: { in: ActiveSupport::TimeZone.all.map(&:name),
                message: "%{value} is not a valid timezone" }
  validates :start_day, presence: true

  enum start_day: { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }
end