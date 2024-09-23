class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :title, :phone_number, :admin, :activated

  # belongs_to :company
  # has_many :device_tokens
  has_many :vacations
  
  def phone_number
    Phonelib.parse(object.phone_number).full_e164
  end
end