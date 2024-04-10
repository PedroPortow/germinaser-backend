FactoryBot.define do
  factory :clinic do
    name { Faker::Company.name }
    address { Faker::Address.full_address }
  end
end
