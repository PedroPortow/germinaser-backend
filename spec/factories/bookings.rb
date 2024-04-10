FactoryBot.define do
  factory :booking do
    room 
    user 
    start_time { 2.days.from_now }
    canceled_at { nil }
    name { Faker::Company.name }

    trait :canceled do
      canceled_at { Time.now }
    end
  end
end
