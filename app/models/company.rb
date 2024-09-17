class Company < ApplicationRecord
  has_many :users

  validates :name, presence: true
  validates :timezone, presence: true
  validates :work_week_start, presence: true

  enum work_week_start: {
    monday: 0,
    tuesday: 1,
    wednesday: 2,
    thursday: 3,
    friday: 4,
    saturday: 5,
    sunday: 6
  }
end