class RoomSerializer
  include JSONAPI::Serializer
  attributes :id, :clinic_id, :name
end
