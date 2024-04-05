class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :credits, :name
end
