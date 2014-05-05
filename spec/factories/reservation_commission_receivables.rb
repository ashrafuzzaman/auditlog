# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reservation_commission_receivable do
    type ""
    start_date "2014-05-05 12:01:30"
    end_date "2014-05-05 12:01:30"
    check_in nil
    hotel nil
    invoice nil
    room_charge 1.5
    amount 1.5
  end
end
