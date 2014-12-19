require "rails_helper"

RSpec.describe Question do
  subject { Question.create text: "O rly?" }

  it "removes answers when question removed" do
    subject.answers.create [{ label: "Hai" }, { label: "No" }]
    subject.destroy
    expect(Answer.count).to eq 0
  end

  describe '.random' do
    let!(:question_0) { Question.create(text: "O rly 0?") }
    let!(:question_1) { Question.create(text: "O rly 1?") }
    let!(:question_2) { Question.create(text: "O rly 2?") }

    it "returns n questions" do
      allow(Question).to receive(:rand).and_return(1)
      questions = Question.random(2)
      expect(questions.length).to eq 2
    end

    it "returns random questions" do
      allow(Question).to receive(:rand).and_return(1)
      questions = Question.random(1)
      expect(questions[0].id).to eq question_1.id
    end

    it "subtracts n from maximum offset" do
      allow(Question).to receive(:rand).with(1).and_return(0)
      Question.random(3)
    end

    context "when exclude parameter provided" do
      it "excludes given question" do
        allow(Question).to receive(:rand).and_return(0)
        questions = Question.random(1, exclude: question_0.id)
        expect(questions[0].id).to_not eq question_0.id
      end

      it "excludes multiple questions" do
        allow(Question).to receive(:rand).and_return(0)
        questions = Question.random(2, exclude: [question_0.id, question_1.id])
        expect(questions[0].id).to eq question_2.id
      end

      it "subtracts excluded questions from maximum offset" do
        allow(Question).to receive(:rand).with(1).and_return(0)
        Question.random(1, exclude: [question_0.id, question_1.id])
      end
    end
  end

  describe '#votes_count' do
    it "returns zero for a question with no votes" do
      expect(subject.votes_count).to eq 0
    end

    it "returns the count of votes" do
      subject.answers.create [{ label: "Hai", votes: 2 }, { label: "No", votes: 3 }]
      expect(subject.votes_count).to eq 5
    end
  end
end
