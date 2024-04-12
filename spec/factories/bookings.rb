FactoryBot.define do
  factory :booking do
    room 
    user 
    start_time { 2.days.from_now }
    canceled_at { nil }
    name { Faker::Company.name }
    credit_return_pending { false }
    
    trait :canceled do
      canceled_at { Time.now }
    end
    
    trait :canceled_credit_pending do
      canceled_at { Time.now }
      credit_return_pending { true }
    end
  end
end
