require 'spec_helper'

describe Question do
  it "removes answers when question removed" do
    question = Question.create text: "O rly?"
    question.answers.create [{ label: "Hai" }, { label: "No" }]
    question.destroy
    expect(Answer.count).to eq 0
  end
end
