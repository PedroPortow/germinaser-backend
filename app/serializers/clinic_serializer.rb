class ClinicSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :address

  attribute :formatted_address do |clinic| # TODO: Remover esse teste
    "Localização: #{clinic.address}"
  end
end
