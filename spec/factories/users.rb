FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    full_name { "Test User" }
    confirmed_at { Time.current }

    trait :enterprise do
      role { :business }
      association :company
    end

    trait :admin do
      role { :admin }
    end
  end
end 
