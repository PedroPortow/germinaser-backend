class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :created_at

  #Remember, you can use the attribute method in a serializer to add a property to the JSON response based on an expression you return from a block that has access to the object you’re serializing. For example, you can modify the column name and data format by overwrite attribute:

  attribute :created_date do |user|
    user.created_at && user.created_at.strftime('%m/%d/%Y')
  end
end
