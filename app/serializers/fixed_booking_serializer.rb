class FixedBookingSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :clinic_id, :room_id, :clinic_name, :room_name, :start_time, :end_time, :canceled_at, :day_of_week

  def clinic_id
    object.room.clinic.id
  end

  def room_id
    object.room.id
  end

  def clinic_name
    object.room.clinic.name
  end

  def room_name
    object.room.name
  end

  def start_time
    object.start_time.strftime("%H:%M")
  end

  def end_time
    object.end_time.strftime("%H:%M")
  end

  def day_of_week
    object.day_of_week
  end
end
