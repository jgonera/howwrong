FactoryGirl.define do
  factory :question do
    text "Are you tested?"
    source "Daily Bullshit"
    source_url "http://fakefakecrap.com"

    after(:create) do |question|
      create(:answer, label: 'Yes', is_correct: true, question: question, feedback: create(:positive_feedback))
      create(:answer, label: 'No', question: question)
    end
  end

  factory :answer do
    label "Answer"
    question
    feedback
  end

  factory :feedback do
    text "You suck!"
  end

  factory :positive_feedback, class: Feedback do
    text "You're right!"
    is_positive true
  end
end
