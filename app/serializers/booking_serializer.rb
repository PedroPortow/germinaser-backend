class BookingSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :clinic_id, :room_id, :clinic_name, :room_name, :start_time, :date, :status

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

  def date
    object.start_time.to_date
  end

  def start_time
    object.start_time.strftime("%H:%M")
  end

  def status
    if object.canceled_at.present?
      'canceled'
    elsif object.start_time.future?
      'upcoming'
    else
      'done'
    end
  end
end
