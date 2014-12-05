RSpec.describe Quiz do
  subject(:quiz) { Quiz.create(average_score: 80, times_taken: 2) }

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
