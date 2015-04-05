require "rails_helper"

RSpec.describe Quiz do
  subject(:quiz) { Quiz.create(average_score: 80, times_taken: 2) }

  describe '.random', focus: true do
    let!(:quiz_0) { create(:quiz) }
    let!(:quiz_1) { create(:quiz) }
    let!(:quiz_2) { create(:quiz) }

    it "returns n quizzes" do
      allow(Quiz).to receive(:rand).and_return(1)
      quizzes = Quiz.random(2)
      expect(quizzes.length).to eq 2
    end

    it "returns random quizzes" do
      allow(Quiz).to receive(:rand).and_return(1)
      quizzes = Quiz.random(1)
      expect(quizzes[0].id).to eq quiz_1.id
    end

    it "subtracts n from maximum offset" do
      allow(Quiz).to receive(:rand).with(1).and_return(0)
      Quiz.random(3)
    end

    context "when exclude parameter provided" do
      it "excludes given question" do
        allow(Quiz).to receive(:rand).and_return(0)
        quizzes = Quiz.random(1, exclude: quiz_0.id)
        expect(quizzes[0].id).to_not eq quiz_0.id
      end

      it "excludes multiple quizzes" do
        allow(Quiz).to receive(:rand).and_return(0)
        quizzes = Quiz.random(2, exclude: [quiz_0.id, quiz_1.id])
        expect(quizzes[0].id).to eq quiz_2.id
      end

      it "subtracts excluded quizzes from maximum offset" do
        allow(Quiz).to receive(:rand).with(1).and_return(0)
        Quiz.random(1, exclude: [quiz_0.id, quiz_1.id])
      end
    end
  end

  describe "#register_score!" do
    before :each do
      quiz.register_score!(50)
      quiz.reload
    end

    it "updates average_score" do
      expect(quiz.average_score).to eq(70)
    end

    it "updates times_taken" do
      expect(quiz.times_taken).to eq(3)
    end
  end
end
