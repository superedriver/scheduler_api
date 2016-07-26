FactoryGirl.define do
  factory :event do
    name "Meeting"
    description "Meeting with Projector"
    date_start "2016-07-22 14:05:29"
    date_finish "2016-07-22 14:05:29"
    assosiate 1
    association :user
  end
end
