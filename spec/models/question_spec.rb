require 'spec_helper'

describe Question do
  subject { Question.create text: "O rly?" }

  it "removes answers when question removed" do
    subject.answers.create [{ label: "Hai" }, { label: "No" }]
    subject.destroy
    expect(Answer.count).to eq 0
  end

  describe '#votes_count', wip: true do
    it "returns zero for a question with no votes" do
      expect(subject.votes_count).to eq 0
    end

    it "returns the count of votes" do
      subject.answers.create [{ label: "Hai", votes: 2 }, { label: "No", votes: 3 }]
      expect(subject.votes_count).to eq 5
    end
  end
end
