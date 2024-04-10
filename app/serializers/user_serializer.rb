class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :credits, :name, :role, :bookings_count 

  def bookings_count
    object.bookings.count
  end 
end
