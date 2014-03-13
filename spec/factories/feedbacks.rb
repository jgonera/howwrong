# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feedback do
    text "MyText"
    is_positive false
  end
end
