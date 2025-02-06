FactoryBot.define do
  factory :company do
    name { "Test Company" }
    description { "Test company description" }
    website { "http://example.com" }
    address { "Test address" }
  end
end 
