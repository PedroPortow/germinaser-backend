class ClinicSerializer  < ActiveModel::Serializer
  attributes :id, :name, :address, :formatted_address
end
