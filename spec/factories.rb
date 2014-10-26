FactoryGirl.define do
  factory :question do
    text "Are you tested?"
    source "Daily Bullshit"
    source_url "http://fakefakecrap.com"

    after :create do |question|
      create :answer, :correct, question: question
      create :answer, question: question
    end
  end

  factory :answer do
    sequence(:label) { |n| "Answer #{n}" }
    question
    feedback

    trait :correct do
      is_correct true
      association :feedback, :positive
    end
  end

  factory :feedback do
    text "You suck!"

    trait :positive do
      text "You rock!"
      is_positive true
    end
  end

  factory :quiz do
    title "Super fun quiz"
  end
end
