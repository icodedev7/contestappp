# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contest do
    name "MyString"
    product_id 1
    start_date "2015-01-11 23:29:59"
    end_date "2016-01-11 23:29:59"
    max_results 1
    order_id 1
    product_name "MyString"
  end
end
