class VacationSerializer < ActiveModel::Serializer
  attributes :id, :start_date, :end_date, :user_id
  belongs_to :user
end