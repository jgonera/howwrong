require "rails_helper"

RSpec.describe Question do
  let(:question) { create(:question) }

  it "removes answers when question removed" do
    question.answers.create [{ label: "Hai" }, { label: "No" }]
    question.destroy
    expect(Answer.count).to eq 0
  end

  describe "validation" do
    let(:question) { build(:question) }

    it "requires text" do
      question.text = ""
      expect(question).not_to be_valid
    end

    it "requires source" do
      question.source = ""
      expect(question).not_to be_valid
    end

    it "requires source_url" do
      question.source_url = ""
      expect(question).not_to be_valid
    end
  end

  describe '.random' do
    let!(:question_0) { create(:question) }
    let!(:question_1) { create(:question) }
    let!(:question_2) { create(:question) }

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
      expect(question.votes_count).to eq 0
    end

    it "returns the count of votes" do
      question.answers.create [{ label: "Hai", votes: 2 }, { label: "No", votes: 3 }]
      expect(question.votes_count).to eq 5
    end
  end
end
