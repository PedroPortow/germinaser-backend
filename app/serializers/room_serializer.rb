class RoomSerializer < ActiveModel::Serializer
  attributes :id, :clinic_id, :name, :clinic_name

  def clinic_name
    object.clinic.name
  end
end
