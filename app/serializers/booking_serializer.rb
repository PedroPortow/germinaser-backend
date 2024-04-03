class BookingSerializer
  include JSONAPI::Serializer
  attributes :id, :room_id, :user_id, :start_time, :canceled_at
end
