FactoryGirl.define do
  factory :user do
    name "John Doe"
    sequence(:email) { |i| "email#{i}@gmail.com" }
    password "qwerty"
    password_confirmation "qwerty"
  end
end
