# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reservation_commission_invoice do
    type ""
    title "MyString"
    total_room_charge 1.5
    total_amount 1.5
    status "MyString"
    invoiced_at "2014-05-05 12:07:18"
  end
end
