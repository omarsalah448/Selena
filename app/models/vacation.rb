class Vacation < ApplicationRecord
  belongs_to :user

  validates :start_date, :end_date, presence: true
  validate :start_date_cannot_be_in_the_past
  validate :end_date_after_start_date

  # this scope is used to get all the vacations that overlap with the given start and end date
  scope :overlapping, ->(start_date, end_date) {
    where("start_date <= ? AND end_date >= ?", end_date, start_date)
  }

  private

  def start_date_cannot_be_in_the_past
    errors.add(:start_date, "can't be in the past") if start_date.present? && start_date < Date.today
  end

  def end_date_after_start_date
    errors.add(:end_date, "can't be before the start date") if end_date.present? && start_date.present? && end_date < start_date
  end
end