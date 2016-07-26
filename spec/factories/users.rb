FactoryGirl.define do
  factory :user do
    name "John Doe"
    sequence(:email) { |i| "email#{i}@gmail.com" }
  end
end
