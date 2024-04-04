class BookingSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :clinic_name, :room_name, :start_time, :date

  def clinic_name
    object.room.clinic.name
  end

  def room_name
    object.room.name
  end

  def date
    object.start_time.to_date
  end

  def start_time
    object.start_time.strftime("%H:%M")
  end
end
