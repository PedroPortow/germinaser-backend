FactoryBot.define do
  factory :room do
    name { "Sala #{Faker::Alphanumeric.alpha(number: 2)}" }
    clinic  { create(:clinic) }
  end
end
