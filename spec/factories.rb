FactoryGirl.define do
  factory :question do
    text "Are you tested?"
    source "Daily Bullshit"
    source_url "http://fakefakecrap.com"

    after(:create) do |question|
      create(:answer, label: 'Yes', is_correct: true, question: question)
      create(:answer, label: 'No', question: question)
    end
  end

  factory :answer do
    label "Answer"
    question
  end
end
