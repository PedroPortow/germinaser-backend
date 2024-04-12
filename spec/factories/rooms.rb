FactoryBot.define do
  factory :room do
    sequence(:name) { |n| "Room #{n}" } 
    clinic  { create(:clinic) }
  end
end
