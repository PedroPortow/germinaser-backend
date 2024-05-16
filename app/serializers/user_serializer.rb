class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :credits, :name, :role,
             :active_bookings_count, :done_bookings_count, 
             :canceled_bookings_count, :total_bookings_count

  def active_bookings_count
    object.bookings.scheduled.count
  end

  def done_bookings_count
    object.bookings.completed.count
  end

  def canceled_bookings_count
    object.bookings.canceled.count
  end

  def total_bookings_count
    object.bookings.count
  end
end
